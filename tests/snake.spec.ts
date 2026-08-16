import { bundledReactVersion, expect, test } from './fixtures'
import type { Page } from '@playwright/test'

test.use({ example: 'snake' })

function snakeCells(page: Page) {
  return page.evaluate(() =>
    Array.from(document.querySelectorAll('.flex-column > div')).flatMap((row, y) =>
      Array.from(row.children).flatMap((cell, x) =>
        // Empty cells are white, snake cells are not.
        getComputedStyle(cell).backgroundColor === 'rgb(255, 255, 255)' ? [] : [`${x},${y}`])))
}

const initial = ['5,10', '6,10', '7,10', '8,10', '9,10', '10,10']

test('renders a 20x20 board', async ({ page }) => {
  await expect(page.locator('.flex-column > div')).toHaveCount(20)
  await expect(page.locator('.flex-column > div > div')).toHaveCount(400)
})

test('lays the snake out across the middle of the board', async ({ page }) => {
  await expect.poll(() => snakeCells(page)).toEqual(initial)

  const cell = (x: number, y: number) =>
    page.locator('.flex-column > div').nth(y).locator('> div').nth(x)
  await expect(cell(5, 10)).toHaveCSS('background-color', 'rgb(255, 0, 255)')
  await expect(cell(6, 10)).toHaveCSS('background-color', 'rgb(255, 45, 255)')
})

test('moves left and up', async ({ page }) => {
  await expect.poll(() => snakeCells(page)).toEqual(initial)

  await page.getByRole('button', { name: '⬅️' }).click()
  await expect.poll(() => snakeCells(page)).toEqual(['4,10', '5,10', '6,10', '7,10', '8,10', '9,10'])

  await page.getByRole('button', { name: '⬆️' }).click()
  await expect.poll(() => snakeCells(page)).toEqual(['4,9', '4,10', '5,10', '6,10', '7,10', '8,10'])
})

test('moves down and right', async ({ page }) => {
  await expect.poll(() => snakeCells(page)).toEqual(initial)

  await page.getByRole('button', { name: '⬇️' }).click()
  await expect.poll(() => snakeCells(page)).toEqual(['5,10', '6,10', '7,10', '8,10', '9,10', '5,11'])

  await page.getByRole('button', { name: '➡️' }).click()
  await expect.poll(() => snakeCells(page)).toEqual(['5,10', '6,10', '7,10', '8,10', '5,11', '6,11'])
})

test('bundles React 19', async ({ page }) => {
  expect(await bundledReactVersion(page)).toMatch(/^19\./)
})
