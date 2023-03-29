local util = require 'lspconfig.util'

local bin_name = 'dot-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'dot' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nikeee/dot-language-server

`dot-language-server` can be installed via `npm`:
```sh
npm install -g dot-language-server
```
    ]],
  },
}
