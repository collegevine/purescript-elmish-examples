let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.0-20190611/src/packages.dhall

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall
          "v0.1.1"
      , elmish-html =
          https://raw.githubusercontent.com/collegevine/purescript-elmish-html/master/elmish-html.dhall
          "purescript-13"
      }

in  upstream // additions
