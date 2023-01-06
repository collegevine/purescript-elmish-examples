let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.15.4-20220924/src/packages.dhall
        sha256:81067801c9959b544ac870b392b8520d516b32bddaf9c98b32d40037200c071f

in  upstream
  with elmish.version = "v0.9.3"
  with elmish-html.version = "v0.8.1"
