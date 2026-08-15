#!/bin/sh
# Build and bundle one example into <example>/output/index.js, exposed as the
# global `Main` that its index.html calls.
#
# Usage: scripts/bundle.sh <example> [extra esbuild args...]
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
PATH="$root/node_modules/.bin:$PATH"
export PATH

if [ $# -eq 0 ]; then
  echo "usage: scripts/bundle.sh <counter|snake|todo-mvc> [esbuild args...]" >&2
  exit 1
fi
example=$1
shift

# `counter` is pinned to React 17 while the other examples are on React 19, so
# its bare `react` / `react-dom` imports are redirected to the npm aliases
# holding the React 17 copies. This belongs on the spago step, which is where
# React gets inlined into bundle.js; by the esbuild pass below there is nothing
# left to redirect. `--bundler-args` takes one esbuild argument per occurrence,
# so the flag is repeated rather than given a single quoted string.
case $example in
  counter)
    spago bundle -p "$example" \
      --bundler-args --alias:react=react-17 \
      --bundler-args --alias:react-dom=react-dom-17
    ;;
  *)
    spago bundle -p "$example"
    ;;
esac

# `spago bundle` only emits ESM, so a second pass re-formats it as an IIFE
# carrying the global.
esbuild "$example/output/bundle.js" \
  --bundle \
  --outfile="$example/output/index.js" \
  --global-name=Main \
  "$@"
