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
    , "undefined-is-not-a-problem"
    ]
, packages =
    ./packages.dhall
}
