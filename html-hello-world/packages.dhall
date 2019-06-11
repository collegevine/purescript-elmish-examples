let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.0-20190611/src/packages.dhall sha256:2631fe1dce429e5f27324e59cc834e8e8832a5d533423952105c7446320a3648

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall sha256:53db5768030b58bbcfc2f52ae0548b0487defff9dab9105adb19c37c3caa5109
          "v0.1.1"
      , elmish-html =
          https://raw.githubusercontent.com/collegevine/purescript-elmish-html/master/elmish-html.dhall sha256:30e58781aa349b39d388d4570ad31a830a4160dc0b2d6d619a4eb8dd0d4cf040
          "purescript-13"
      }

in  upstream // additions
