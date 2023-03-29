local util = require 'lspconfig.util'

local bin_name = 'cssmodules-language-server'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
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
