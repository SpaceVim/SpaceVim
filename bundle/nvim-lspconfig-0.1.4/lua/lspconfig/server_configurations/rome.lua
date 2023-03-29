local util = require 'lspconfig.util'

local bin_name = 'rome'
local cmd = { bin_name, 'lsp-proxy' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'lsp-proxy' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or util.find_node_modules_ancestor(fname)
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://rome.tools

Language server for the Rome Frontend Toolchain.

```sh
npm install [-g] rome
```
]],
    default_config = {
      root_dir = [[root_pattern('package.json', 'node_modules', '.git')]],
    },
  },
}
