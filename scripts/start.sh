#!/bin/sh
# Build one example and serve it at http://localhost:8080/.
#
# Usage: npm run start -- <counter|snake|todo-mvc>
#
# The `--` separator is what makes npm forward the example name through to here.
set -eu

example=${1:-}
if [ -z "$example" ]; then
  echo "usage: npm run start -- <counter|snake|todo-mvc>" >&2
  exit 1
fi

# --servedir makes the example directory the server root, so the example is
# served at the bare root rather than on a sub-path.
exec "$(dirname "$0")/bundle.sh" "$example" \
  --serve=8080 \
  --servedir="$example"
