#!/bin/sh
# Build and bundle every example.
set -eu

for example in counter snake todo-mvc; do
  "$(dirname "$0")/bundle.sh" "$example"
done
