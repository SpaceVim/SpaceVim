local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'v', 'ls' },
    filetypes = { 'vlang' },
    root_dir = util.root_pattern('v.mod', '.git'),
  },
  docs = {
    description = [[
https://github.com/vlang/vls

V language server.

`v-language-server` can be installed by following the instructions [here](https://github.com/vlang/vls#installation).
```
]],
    default_config = {
      root_dir = [[root_pattern("v.mod", ".git")]],
    },
  },
}
