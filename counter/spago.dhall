{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-snake"
, dependencies =
    [ "aff"
    , "arrays"
    , "bifunctors"
    , "datetime"
    , "effect"
    , "elmish-html"
    , "elmish"
    , "foldable-traversable"
    , "maybe"
    , "prelude"
    , "psci-support"
    ]
, packages =
    ./packages.dhall
}
