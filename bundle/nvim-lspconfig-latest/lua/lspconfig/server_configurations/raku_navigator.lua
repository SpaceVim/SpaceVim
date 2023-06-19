local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {},
    filetypes = { 'raku' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/bscan/RakuNavigator
A Raku language server
**By default, raku_navigator doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.
Clone the RakuNavigator repo, install based on the [instructions](https://github.com/bscan/raku_Navigator#installation-for-other-editors),
and point `cmd` to `server.js` inside the `server/out` directory:
```lua
cmd = {'node', '<path_to_repo>/server/out/server.js', '--stdio'}
```
At minimum, you will need `raku` in your path. If you want to use a non-standard `raku` you will need to set your configuration like so:
```lua
settings = {
  raku_navigator = {
    rakuPath = '/some/odd/location/my-raku'
  }
}
```
The `contributes.configuration.properties` section of `raku_navigator`'s `package.json` has all available configuration settings. All
settings have a reasonable default, but, at minimum, you may want to point `raku_navigator` at your `raku_tidy` and `raku_critic` configurations.
]],
  },
}
