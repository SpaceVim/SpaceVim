local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {},
    filetypes = { 'perl' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/bscan/PerlNavigator

A Perl language server

**By default, perlnavigator doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.

Clone the PerlNavigator repo, install based on the [instructions](https://github.com/bscan/PerlNavigator#installation-for-other-editors),
and point `cmd` to `server.js` inside the `server/out` directory:

```lua
cmd = {'node', '<path_to_repo>/server/out/server.js', '--stdio'}
```

At minimum, you will need `perl` in your path. If you want to use a non-standard `perl` you will need to set your configuration like so:
```lua
settings = {
  perlnavigator = {
    perlPath = '/some/odd/location/my-perl'
  }
}
```

The `contributes.configuration.properties` section of `perlnavigator`'s `package.json` has all available configuration settings. All
settings have a reasonable default, but, at minimum, you may want to point `perlnavigator` at your `perltidy` and `perlcritic` configurations.
]],
  },
}
