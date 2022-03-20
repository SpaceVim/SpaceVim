local util = require 'lspconfig.util'

local bin_name = 'purescript-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'purescript' },
    root_dir = util.root_pattern('bower.json', 'psc-package.json', 'spago.dhall'),
  },
  docs = {
    description = [[
https://github.com/nwolverson/purescript-language-server
`purescript-language-server` can be installed via `npm`
```sh
npm install -g purescript-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("spago.dhall, 'psc-package.json', bower.json")]],
    },
  },
}
