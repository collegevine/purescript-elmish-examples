let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.4/src/packages.dhall sha256:205829948db98d5bab8cd74e811de9b0d2a6bf3802031904db4007ee6d773a28

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall sha256:b09a2cec99cd53d59399ad9eb2cf0fe923da7d6a80c58d21d3ef881ecd582a6b
          "forks"
      , elmish-html =
          https://raw.githubusercontent.com/collegevine/purescript-elmish-html/master/elmish-html.dhall sha256:30e58781aa349b39d388d4570ad31a830a4160dc0b2d6d619a4eb8dd0d4cf040
          "v0.1.2"
      }

in  upstream // additions
