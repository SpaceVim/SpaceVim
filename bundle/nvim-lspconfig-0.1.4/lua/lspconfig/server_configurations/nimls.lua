local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nimlsp' },
    filetypes = { 'nim' },
    root_dir = function(fname)
      return util.root_pattern '*.nimble'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/PMunch/nimlsp

`nimlsp` can be installed via the `nimble` package manager:

```sh
nimble install nimlsp
```
    ]],
  },
}
