local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.taplo = {
  default_config = {
    cmd = { 'taplo-lsp', 'run' },
    filetypes = { 'toml' },
    root_dir = function(fname)
      return util.root_pattern '*.toml'(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/lsp/

Language server for Taplo, a TOML toolkit.

`taplo-lsp` can be installed via `cargo`:
```sh
cargo install taplo-lsp
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.toml", ".git") or dirname]],
    },
  },
}
