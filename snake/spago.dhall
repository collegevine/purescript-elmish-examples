{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-snake"
, dependencies =
    [ "arrays"
    , "effect"
    , "elmish-html"
    , "elmish"
    , "maybe"
    , "prelude"
    ]
, packages =
    ./packages.dhall
}
