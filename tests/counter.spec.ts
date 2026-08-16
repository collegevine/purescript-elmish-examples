import { bundledReactVersion, expect, test } from './fixtures'
import type { Page } from '@playwright/test'

test.use({ example: 'counter' })

const examples = ['Simple counter', 'Two counters', 'Array of counters', 'Reporting progress']

/** Frame lists the examples down the left and renders the selected one in the card. */
async function open(page: Page, title: string) {
  const item = page.locator('.list-group-item', { hasText: title })
  await item.click()
  await expect(item).toHaveClass(/active/)
}

test('lists every example, with the first one selected', async ({ page }) => {
  const items = page.locator('.list-group-item')
  await expect(items).toHaveText(examples)
  await expect(items.first()).toHaveClass(/active/)
})

test('counts up and down', async ({ page }) => {
  const card = page.locator('.card-body')
  const count = card.locator('h2')

  await expect(count).toHaveText('0')
  await card.getByRole('button', { name: 'Inc' }).click()
  await card.getByRole('button', { name: 'Inc' }).click()
  await expect(count).toHaveText('2')
  await card.getByRole('button', { name: 'Dec' }).click()
  await expect(count).toHaveText('1')
})

test('keeps two composed counters independent', async ({ page }) => {
  await open(page, 'Two counters')

  const counters = page.locator('.card-body .col-6')
  await expect(counters).toHaveCount(2)

  await counters.first().getByRole('button', { name: 'Inc' }).click()
  await expect(counters.first().locator('h2')).toHaveText('1')
  await expect(counters.last().locator('h2')).toHaveText('0')
})

test('routes messages to the right counter in an array', async ({ page }) => {
  await open(page, 'Array of counters')

  const rows = page.locator('.card-body .row.mb-3')
  await expect(rows.locator('.col-1')).toHaveText(['1', '2', '3', '4', '5'])

  await rows.nth(2).getByRole('button', { name: 'Inc' }).click()
  await rows.nth(2).getByRole('button', { name: 'Inc' }).click()
  await rows.nth(4).getByRole('button', { name: 'Dec' }).click()
  await expect(rows.locator('h2')).toHaveText(['0', '0', '2', '0', '-1'])
})

test('reports progress from a forked effect, then increments', async ({ page }) => {
  await open(page, 'Reporting progress')

  const card = page.locator('.card-body')
  await card.getByRole('button', { name: 'Inc Slowly' }).click()

  // The bar is styled by width alone, so it is measured by its inline style
  // rather than by visibility: at 0% it has no box to be visible in.
  await expect(card.locator('.progress-bar')).toHaveAttribute('style', /width: [1-9]/)

  await expect(card.locator('h2')).toHaveText('1', { timeout: 15_000 })
  await expect(card.locator('.progress-bar')).toHaveCount(0)
  await expect(card.getByRole('button', { name: 'Inc Slowly' })).toBeVisible()
})

// This example is the only one holding elmish-html's React 17 module set and
// bundle.sh's react-17 aliases up to a browser. We want this one example on
// React 17 specifically, so that the React 17 setup is tested.
test('bundles React 17', async ({ page }) => {
  expect(await bundledReactVersion(page)).toMatch(/^17\./)
})
