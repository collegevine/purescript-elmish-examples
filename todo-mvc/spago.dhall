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
    , "foreign-object"
    , "maybe"
    , "prelude"
    , "psci-support"
    , "web-dom"
    , "web-events"
    , "web-html"
    ]
, packages =
    ./packages.dhall
}
