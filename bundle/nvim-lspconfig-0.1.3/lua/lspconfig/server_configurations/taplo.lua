local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    root_dir = function(fname)
      return util.root_pattern '*.toml'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://taplo.tamasfe.dev/lsp/

Language server for Taplo, a TOML toolkit.

`taplo-cli` can be installed via `cargo`:
```sh
cargo install --locked taplo-cli
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.toml", ".git")]],
    },
  },
}
