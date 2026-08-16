import { test as base, expect, type Page } from '@playwright/test'
import { spawn, type ChildProcess } from 'node:child_process'
import { once } from 'node:events'
import path from 'node:path'

export type Example = 'counter' | 'snake' | 'todo-mvc'

const repoRoot = path.resolve(__dirname, '..')
const servedUrl = /(http:\/\/127\.0\.0\.1:\d+\/)/
const startupTimeout = 180_000

/**
 * Runs `npm start -- <example> 0` and resolves once esbuild reports the URL it
 * is serving on.
 */
async function startExample(example: Example) {
  const proc = spawn('npm', ['start', '--silent', '--', example, '0'], {
    cwd: repoRoot,
    // esbuild's serve mode shuts down the moment stdin reaches EOF, so it needs
    // a pipe held open.
    stdio: ['pipe', 'pipe', 'pipe'],

    // This puts npm, the shell script and esbuild in one process group, which
    // is what makes it possible to take all three down together below.
    detached: true,
  })

  let output = ''
  const url = await new Promise<string>((resolve, reject) => {
    const read = (chunk: Buffer) => {
      output += chunk
      const match = output.match(servedUrl)
      if (match) resolve(match[1])
    }
    proc.stdout.on('data', read)
    proc.stderr.on('data', read)
    proc.on('error', reject)
    proc.on('exit', code =>
      reject(new Error(`\`npm start -- ${example}\` exited with code ${code} before serving:\n${output}`)))
  })

  return { proc, url }
}

async function stopExample(proc: ChildProcess) {
  const exited = once(proc, 'exit')
  // Closing stdin is esbuild's own shutdown signal; killing the process group is
  // the fallback for anything that outlives it and keeps holding the port.
  proc.stdin?.end()
  const fallback = setTimeout(() => {
    try {
      process.kill(-proc.pid!, 'SIGKILL')
    } catch {
      // Already gone, which is the outcome we were after anyway.
    }
  }, 5_000)
  await exited
  clearTimeout(fallback)
}

/**
 * Stands in for the React DevTools extension. React hands every renderer that
 * installs itself to this hook, and the renderer carries its version. We write
 * the version to `window.__reactVersions` so that it can be later read out of
 * it and asserted.
 */
function installReactProbe() {
  const versions: string[] = []
  ;(window as any).__reactVersions = versions
  ;(window as any).__REACT_DEVTOOLS_GLOBAL_HOOK__ = {
    renderers: new Map(),
    supportsFiber: true,
    isDisabled: false,
    inject: (renderer: { version: string }) => versions.push(renderer.version),
    checkDCE: () => {},
    onCommitFiberRoot: () => {},
    onCommitFiberUnmount: () => {},
    onPostCommitFiberRoot: () => {},
    on: () => {},
    off: () => {},
    emit: () => {},
    getFiberRoots: () => new Set(),
  }
}

/**
 * The version of React the example under test actually bundled. It is read out
 * of `window.__reactVersions`, where it's written from the
 * `__REACT_DEVTOOLS_GLOBAL_HOOK__` in `installReactProbe` above.
*/
export async function bundledReactVersion(page: Page): Promise<string> {
  const versions = await page.evaluate(() => (window as any).__reactVersions as string[])
  expect(versions, 'exactly one React renderer should have registered itself').toHaveLength(1)
  return versions[0]
}

type Options = { example?: Example }
type Fixtures = { appUrl: string }

export const test = base.extend<{}, Options & Fixtures>({
  // Set per spec file with `test.use({ example: '...' })`.
  example: [undefined, { scope: 'worker', option: true }],

  appUrl: [
    async ({ example }, use) => {
      if (typeof example !== 'string') throw new Error('test.use({ example: ... }) must be called in the spec file')
      const { proc, url } = await startExample(example)
      await use(url)
      await stopExample(proc)
    },
    { scope: 'worker', timeout: startupTimeout },
  ],

  page: async ({ page, appUrl }, use) => {
    const errors: string[] = []
    page.on('pageerror', error => errors.push(String(error)))
    await page.addInitScript(installReactProbe)
    await page.goto(appUrl)

    await use(page)

    expect(errors, 'the example threw an uncaught error').toEqual([])
  },
})

export { expect } from '@playwright/test'
