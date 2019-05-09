const path = require("path")

module.exports.mkConfig = dirname => ({
  mode: "development",
  entry: "boot.js",
  output: {
    path: path.resolve(dirname, "built"),
    filename: "bundle.js"
  },
  resolve: {
    modules: [
      "node_modules",
      path.resolve(dirname, "src")
    ],
    extensions: [".js", ".jsx", ".purs"],
  },
  devServer: {
    contentBase: path.resolve(dirname, "static")
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        loader: "babel-loader",
        options: {
          babelrc: true
        },
        exclude: [/node_modules/],
      },
      {
        test: /\.purs$/,
        loader: "purs-loader",
        exclude: /node_modules/,
        options: {
          psc: "psa",
          pscIde: true,
          bundle: true,
          pscArgs: {
            sourceMaps: false,
            strict: true, // Warnings as errors
            stash: true, // Persist warnings between compilations
            censorLib: true, // Do not emit warnings from libraries

            censorCodes: [
              "ImplicitQualifiedImportReExport"
            ],
          },
        },
      }
    ]
  }
})
