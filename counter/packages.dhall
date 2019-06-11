let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.0-20190611/src/packages.dhall sha256:2631fe1dce429e5f27324e59cc834e8e8832a5d533423952105c7446320a3648

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall sha256:53db5768030b58bbcfc2f52ae0548b0487defff9dab9105adb19c37c3caa5109
          "v0.1.0"
      }

in  upstream // additions
