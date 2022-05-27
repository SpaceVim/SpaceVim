local util = require 'lspconfig.util'

local bin_name = 'cucumber-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'cucumber' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://cucumber.io
https://github.com/cucumber/common
https://www.npmjs.com/package/@cucumber/language-server

Language server for Cucumber.

`cucumber-language-server` can be installed via `npm`:
```sh
npm install -g @cucumber/language-server
```
    ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
