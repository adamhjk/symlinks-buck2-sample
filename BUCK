# A list of available rules and their signatures can be found here: https://buck2.build/docs/api/rules/

load("//build-rules/ts.bzl", "pnpm_install")

pnpm_install(
  name = "pnpm-install",
  srcs = [
    "thing1/package.json",
    "thing2/package.json",
  ],
  visibility = ["PUBLIC"]
)
