local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cssmodules-language-server' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_dir = util.find_package_json_ancestor,
  },
  docs = {
    description = [[
https://github.com/antonk52/cssmodules-language-server

Language server for autocompletion and go-to-definition functionality for CSS modules.

You can install cssmodules-language-server via npm:
```sh
npm install -g cssmodules-language-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("package.json")]],
    },
  },
}
