#!/bin/sh
# Build one example and serve it at http://localhost:<port>/, port 8080 default.
#
# Usage: npm run start -- <counter|snake|todo-mvc> [port]
#
set -eu

example=${1:-}
if [ -z "$example" ]; then
  echo "usage: npm run start -- <counter|snake|todo-mvc> [port]" >&2
  exit 1
fi
port=${2:-8080}

# --servedir makes the example directory the server root, so the example is
# served at the bare root rather than on a sub-path.
exec "$(dirname "$0")/bundle.sh" "$example" \
  --serve="$port" \
  --servedir="$example"
