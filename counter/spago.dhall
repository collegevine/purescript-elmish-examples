{ sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
, name =
    "purescript-elmish-examples-counter: Counterexample"
, dependencies =
    [ "elmish", "psci-support" ]
, packages =
    ./packages.dhall
}
