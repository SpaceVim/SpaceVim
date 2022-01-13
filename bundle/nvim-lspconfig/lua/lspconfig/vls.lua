local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local name = 'vls'

configs[name] = {
  default_config = {
    filetypes = { 'vlang' },
    root_dir = util.root_pattern('v.mod', '.git'),
  },
  docs = {
    description = [[
https://github.com/vlang/vls

V language server.

`v-language-server` can be installed by following the instructions [here](https://github.com/vlang/vls#installation).

**By default, v-language-server doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your unzipped and compiled v-language-server.

```lua
-- set the path to the vls installation;
local vls_root_path = vim.fn.stdpath('cache')..'/lspconfig/vls'
local vls_binary = vls_root_path.."/cmd/vls/vls"

require'lspconfig'.vls.setup {
  cmd = {vls_binary},
}
```
]],
    default_config = {
      root_dir = [[root_pattern("v.mod", ".git")]],
    },
  },
}
