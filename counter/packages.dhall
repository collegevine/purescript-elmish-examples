let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.12.5-20190508/src/packages.dhall sha256:8ef3a6d6d123e05933997426da68ef07289e1cbbdd2a844b5d10c9159deef65a

let additions =
      { elmish =
          https://raw.githubusercontent.com/collegevine/purescript-elmish/master/elmish.dhall sha256:53db5768030b58bbcfc2f52ae0548b0487defff9dab9105adb19c37c3caa5109
          "v0.0.4"
      }

in  upstream // additions
