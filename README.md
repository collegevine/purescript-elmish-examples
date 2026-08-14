[![build](https://github.com/collegevine/purescript-elmish-examples/actions/workflows/build.yml/badge.svg)](https://github.com/collegevine/purescript-elmish-examples/actions/workflows/build.yml)

This repo contains a few examples of UI written with the [purescript-elmish](https://github.com/collegevine/purescript-elmish) library.

The examples live in one Spago workspace rooted here. Every subdirectory is a workspace package with its own entry point, sources and `index.html`; dependencies, the package set and the build are shared and driven from the root.

Requires Node 22.5.0 or newer (Spago 1.x).

```bash
npm install               # install dependencies for the whole workspace
npm run build             # build and bundle all examples
npm run start -- counter  # dev server, then open http://localhost:8080/
```

`start` takes the name of any example: `counter`, `snake` or `todo-mvc`.

More docs are forthcoming.
