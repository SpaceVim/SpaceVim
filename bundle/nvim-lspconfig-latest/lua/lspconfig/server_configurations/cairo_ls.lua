local util = require 'lspconfig.util'

local bin_name = 'cairo-language-server'
local cmd = { bin_name, '/C', '--node-ipc' }

return {
  default_config = {
    init_options = { hostInfo = 'neovim' },
    cmd = cmd,
    filetypes = { 'cairo' },
    root_dir = util.root_pattern('Scarb.toml', 'cairo_project.toml', '.git'),
  },
  docs = {
    description = [[
[Cairo Language Server](https://github.com/starkware-libs/cairo/tree/main/crates/cairo-lang-language-server)

First, install cairo following [this tutorial](https://medium.com/@elias.tazartes/ahead-of-the-curve-install-cairo-1-0-alpha-and-prepare-for-regenesis-85f4e3940e20)

Then enable cairo language server in your lua configuration.
```lua
require'lspconfig'.cairo_ls.setup{}
```

*cairo-language-server is still under active development, some features might not work yet !*
]],
    default_config = {
      root_dir = [[root_pattern("Scarb.toml", "cairo_project.toml", ".git")]],
    },
  },
}
