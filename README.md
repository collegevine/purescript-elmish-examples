[![build](https://github.com/collegevine/purescript-elmish-examples/actions/workflows/build.yml/badge.svg)](https://github.com/collegevine/purescript-elmish-examples/actions/workflows/build.yml)

This repo contains a few examples of UI written with the [purescript-elmish](https://github.com/collegevine/purescript-elmish) library.

The examples live in one Spago workspace rooted here. Every subdirectory is a workspace package with its own entry point, sources and `index.html`; dependencies, the package set and the build are shared and driven from the root.

Requires Node 22.5.0 or newer (Spago 1.x).

```bash
npm install               # install dependencies for the whole workspace
npm run build             # build and bundle all examples
npm run start -- counter  # dev server, then open http://localhost:8080/
npm test                  # smoke-test every example in a browser
npm test -- --headed      # test with a non-headless browser, so it's visible
```

`start` takes the name of any example: `counter`, `snake` or `todo-mvc`.

The tests are Playwright, and live outside the examples in `tests/`. The idea is that the tests are completely black-box. They're supposed to test the whole setup as a whole, make sure Elmish itself works correctly, as well as Elmish.HTML. Each test starts its example via `npm start` and drives it in a headless browser. First run needs `npx playwright install chromium`.
