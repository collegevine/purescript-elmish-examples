let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.8-20201223/src/packages.dhall sha256:a1a8b096175f841c4fef64c9b605fb0d691229241fd2233f6cf46e213de8a185

let additions = {=}

in  upstream // additions
