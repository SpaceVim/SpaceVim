local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'flux-lsp' },
    filetypes = { 'flux' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/influxdata/flux-lsp
`flux-lsp` can be installed via `cargo`:
```sh
cargo install --git https://github.com/influxdata/flux-lsp
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
