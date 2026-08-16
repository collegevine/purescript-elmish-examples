import { bundledReactVersion, expect, test } from './fixtures'
import type { Page } from '@playwright/test'

test.use({ example: 'todo-mvc' })

const hyperdrive = 'Fix the hyperdrive'
const blueMilk = 'Buy blue milk'

async function add(page: Page, name: string) {
  const input = page.locator('.new-todo')
  await input.fill(name)
  await input.press('Enter')
}

async function addBoth(page: Page) {
  await add(page, hyperdrive)
  await add(page, blueMilk)
  await expect(page.locator('.todo-list li')).toHaveCount(2)
}

test('starts empty', async ({ page }) => {
  await expect(page.getByRole('heading', { name: 'todos' })).toBeVisible()
  await expect(page.locator('.todo-list li')).toHaveCount(0)
  await expect(page.locator('.todo-count')).toHaveText('0 items left')
})

test('adds todos and clears the input', async ({ page }) => {
  await addBoth(page)

  await expect(page.locator('.todo-list li label')).toHaveText([hyperdrive, blueMilk])
  await expect(page.locator('.todo-count')).toHaveText('2 items left')
  await expect(page.locator('.new-todo')).toHaveValue('')
})

test('completes a todo', async ({ page }) => {
  await addBoth(page)

  await page.locator('.todo-list li').first().locator('.toggle').check()
  await expect(page.locator('.todo-list li').first()).toHaveClass(/completed/)
  await expect(page.locator('.todo-count')).toHaveText('1 items left')
})

test('completes every todo at once', async ({ page }) => {
  await addBoth(page)

  await page.locator('label[for="toggle-all"]').click()
  await expect(page.locator('.todo-list li.completed')).toHaveCount(2)
  await expect(page.locator('.todo-count')).toHaveText('0 items left')
})

test('deletes a todo', async ({ page }) => {
  await addBoth(page)

  const first = page.locator('.todo-list li').first()
  await first.hover()
  await first.locator('.destroy').click()

  await expect(page.locator('.todo-list li label')).toHaveText([blueMilk])
})

test('edits a todo by double-clicking it', async ({ page }) => {
  await addBoth(page)

  const first = page.locator('.todo-list li').first()
  await first.locator('label').dblclick()
  await expect(first).toHaveClass(/editing/)

  // init focuses the edit box from a forked effect, a tick after the render.
  const edit = first.locator('.edit')
  await expect(edit).toBeFocused()

  await edit.fill('Repair the hyperdrive')
  await edit.press('Enter')

  await expect(page.locator('.todo-list li label')).toHaveText(['Repair the hyperdrive', blueMilk])
})

test('filters the list and writes the filter to the route', async ({ page }) => {
  await addBoth(page)
  await page.locator('.todo-list li').first().locator('.toggle').check()

  await page.locator('.filters').getByRole('link', { name: 'Active' }).click()
  await expect(page.locator('.todo-list li label')).toHaveText([blueMilk])
  await expect(page).toHaveURL(/#\/active$/)

  await page.locator('.filters').getByRole('link', { name: 'Completed' }).click()
  await expect(page.locator('.todo-list li label')).toHaveText([hyperdrive])
  await expect(page).toHaveURL(/#\/completed$/)
})

test('follows the route when the hash changes underneath it', async ({ page }) => {
  await addBoth(page)
  await page.locator('.todo-list li').first().locator('.toggle').check()

  await page.evaluate(() => { window.location.hash = '#/completed' })

  await expect(page.locator('.filters a.selected')).toHaveText('Completed')
  await expect(page.locator('.todo-list li label')).toHaveText([hyperdrive])
})

test('bundles React 19', async ({ page }) => {
  expect(await bundledReactVersion(page)).toMatch(/^19\./)
})
