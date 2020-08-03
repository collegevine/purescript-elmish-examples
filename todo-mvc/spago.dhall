{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-counter: Counterexample"
, dependencies =
    [ "elmish", "elmish-html", "psci-support" ]
, packages =
    ./packages.dhall
}
