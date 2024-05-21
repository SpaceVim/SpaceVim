local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'regols' },
    filetypes = { 'rego' },
    root_dir = function(fname)
      return util.root_pattern '*.rego'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kitagry/regols

OPA Rego language server.

`regols` can be installed by running:
```sh
go install github.com/kitagry/regols@latest
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.rego", ".git")]],
      single_file_support = true,
    },
  },
}
