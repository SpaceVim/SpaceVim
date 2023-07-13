local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nimlangserver' },
    filetypes = { 'nim' },
    root_dir = function(fname)
      return util.root_pattern '*.nimble'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nim-lang/langserver


`nim-langserver` can be installed via the `nimble` package manager:
```sh
nimble install nimlangserver
```
    ]],
  },
}
