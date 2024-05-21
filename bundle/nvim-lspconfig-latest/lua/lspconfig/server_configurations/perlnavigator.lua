local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'perlnavigator' },
    filetypes = { 'perl' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/bscan/PerlNavigator

A Perl language server. It can be installed via npm:

```sh
npm i -g perlnavigator-server
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
