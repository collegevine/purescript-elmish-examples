{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-snake"
, dependencies =
    [ "aff"
    , "arrays"
    , "effect"
    , "elmish-html"
    , "elmish"
    , "foldable-traversable"
    , "foreign-object"
    , "maybe"
    , "prelude"
    , "web-dom"
    , "web-events"
    , "web-html"
    ]
, packages =
    ./packages.dhall
}
