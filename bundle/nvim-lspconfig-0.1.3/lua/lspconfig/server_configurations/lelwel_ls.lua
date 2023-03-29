local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lelwel-ls' },
    filetypes = { 'llw' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/0x2a-42/lelwel

Language server for lelwel grammars.

You can install `lelwel-ls` via cargo:
```sh
cargo install --features="lsp" lelwel
```
]],
  },
}
