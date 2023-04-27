A sample project that shows the issues with symlinks and buck2. 

You will need to install:

  * NodeJS
  * [pnpm](https://pnpm.io/installation)

# The setup

This repository has a very basic pnpm workspace with two node packages -
`thing1` and `thing2`. Thing1 has a workspace dependency on Thing2.

# To reproduce

To reproduce the issue, run:

```
buck2 build //:pnpm-install
```

You can then change the version number of `thing1/package.json` to a different
number, and run `buck2 build //:pnpm-install` again. If this is the first time
the buck daemon has started (and there were no node_modules directories), you
will see buck2 run `pnpm install` due to the updated source. You can then do
the same with `thing2/package.json` and it will also work.

Now do:

```
buck2 clean
```

Followed by another

```
buck2 build //:pnpm-install
```

Now the buck2 daemon will have the `node_modules` folders in the tree. If you
change `thing1/package.json` and run `buck2 build //:pnpm-install` again, things
will work as expected. But then change `thing2/package.json` - and the target
will fail to register that any source has changed.

# In short

  * If the buck2 daemon is started when the node_modules hierarchy exists
  * And there are workspace dependencies between two packages
  * Buck2 will track the symlink from `thing1/node_modules/thing_2/package.json`, rather than
    the 'real' `thin2/package.json`.

