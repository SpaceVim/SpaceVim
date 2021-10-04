local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'zeta_note'

configs[server_name] = {
  default_config = {
    filetypes = { 'markdown' },
    root_dir = util.root_pattern '.zeta.toml',
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/artempyanykh/zeta-note-vscode/main/package.json',
    description = [[
https://github.com/artempyanykh/zeta-note

Markdown LSP server for easy note-taking with cross-references and diagnostics.

Binaries can be downloaded from https://github.com/artempyanykh/zeta-note/releases

**By default, zeta-note doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of your zeta-note binary.

```lua
require'lspconfig'.zeta_note.setup{
  cmd = {'path/to/zeta-note'}
}
```
]],
    default_config = {
      root_dir = [[root_pattern(".zeta.toml")]],
    },
  },
}
