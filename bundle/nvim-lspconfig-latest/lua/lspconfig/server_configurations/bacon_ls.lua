local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bacon-ls' },
    filetypes = { 'rust' },
    root_dir = util.root_pattern('.bacon-locations', 'Cargo.toml'),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/crisidev/bacon-ls

A Language Server Protocol wrapper for [bacon](https://dystroy.org/bacon/).
It offers textDocument/diagnostic and workspace/diagnostic capabilities for Rust
workspaces using the Bacon export locations file.

It requires `bacon` and `bacon-ls` to be installed on the system using
[mason.nvim](https://github.com/williamboman/mason.nvim) or manually:util

```sh
$ cargo install --locked bacon bacon-ls
```

Settings can be changed using the `settings` dictionary:util

```lua
settings = {
    -- Bacon export filename, default .bacon-locations
    locationsFile = ".bacon-locations",
    -- Maximum time in seconds the LSP server waits for Bacon to update the
    -- export file before loading the new diagnostics
    waitTimeSeconds = 10
}
```
    ]],
  },
}
