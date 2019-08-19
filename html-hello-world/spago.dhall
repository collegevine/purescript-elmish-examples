{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-html-hello-world: PureScript Elmish HTML Hello World"
, dependencies =
    [ "elmish", "elmish-html", "psci-support" ]
, packages =
    ./packages.dhall
}
