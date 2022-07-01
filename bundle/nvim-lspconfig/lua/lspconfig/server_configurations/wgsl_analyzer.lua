local util = require 'lspconfig.util'

local bin_name = 'wgsl_analyzer'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
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
