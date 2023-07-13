local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'wgsl_analyzer' },
    filetypes = { 'wgsl' },
    root_dir = util.root_pattern '.git',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/wgsl-analyzer/wgsl-analyzer

`wgsl_analyzer` can be installed via `cargo`:
```sh
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer wgsl_analyzer
```
]],
    default_config = {
      root_dir = [[root_pattern(".git"]],
    },
  },
}
