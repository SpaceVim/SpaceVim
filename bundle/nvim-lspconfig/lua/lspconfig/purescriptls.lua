local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'purescriptls'
local bin_name = 'purescript-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'purescript' },
    root_dir = util.root_pattern('bower.json', 'psc-package.json', 'spago.dhall'),
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/nwolverson/vscode-ide-purescript/master/package.json',
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
