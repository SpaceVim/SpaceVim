local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'veryl-ls' },
    filetypes = { 'veryl' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/dalance/veryl

Language server for Veryl

`veryl-ls` can be installed via `cargo`:
 ```sh
 cargo install veryl-ls
 ```
    ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
