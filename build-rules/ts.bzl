def pnpm_install_impl(ctx: "context") -> ["provider"]:
    script = ctx.actions.write("pnpm-install.sh", """#!/bin/bash
set -euxo pipefail
pnpm install 
cp -r node_modules/ $1
cp pnpm-lock.yaml $2
""", is_executable = True);
    node_modules = ctx.actions.declare_output("node_modules", dir = True)
    pnpm_lockfile = ctx.actions.declare_output("pnpm-lock.yaml")

    args = cmd_args([script, node_modules.as_output(), pnpm_lockfile.as_output(),])
    args.hidden([ctx.attrs.srcs])
    ctx.actions.run(args, category = "pnpm", identifier = "install", local_only = True)
    return [DefaultInfo(default_outputs = [node_modules, pnpm_lockfile,])]

pnpm_install = rule(impl = pnpm_install_impl, attrs = {
    "srcs": attrs.list(attrs.source(), default = [], doc = """List of package.json files to track"""),
})
