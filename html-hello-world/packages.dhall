let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.14.0-20210313/src/packages.dhall sha256:ba6368b31902aad206851fec930e89465440ebf5a1fe0391f8be396e2d2f1d87

in  upstream
  with elmish.version = "v0.5.0"
  with elmish-html.version = "v0.3.0"
  with debug.version = "v5.0.0"
