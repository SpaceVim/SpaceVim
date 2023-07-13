local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'futhark', 'lsp' },
    filetypes = { 'futhark', 'fut' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/diku-dk/futhark

Futhark Language Server

This language server comes with the futhark compiler and is run with the command
```
futhark lsp
```
]],
  },
}
