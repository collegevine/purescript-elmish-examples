let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.8/src/packages.dhall sha256:0e95ec11604dc8afc1b129c4d405dcc17290ce56d7d0665a0ff15617e32bbf03

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall sha256:b09a2cec99cd53d59399ad9eb2cf0fe923da7d6a80c58d21d3ef881ecd582a6b
            "v0.2.1"
      , elmish-html =
          https://raw.githubusercontent.com/collegevine/purescript-elmish-html/master/elmish-html.dhall sha256:30e58781aa349b39d388d4570ad31a830a4160dc0b2d6d619a4eb8dd0d4cf040
            "v0.1.3"
      }

in  upstream // additions
