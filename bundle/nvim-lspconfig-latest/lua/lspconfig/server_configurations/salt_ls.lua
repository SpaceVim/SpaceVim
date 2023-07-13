local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'salt_lsp_server' },
    filetypes = { 'sls' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
Language server for Salt configuration files.
https://github.com/dcermak/salt-lsp

The language server can be installed with `pip`:
```sh
pip install salt-lsp
```
    ]],
    default_config = {
      root_dir = [[root_pattern('.git')]],
    },
  },
}
