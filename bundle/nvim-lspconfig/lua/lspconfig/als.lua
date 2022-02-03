local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'als'
local bin_name = 'ada_language_server'

if vim.fn.has 'win32' == 1 then
  bin_name = 'ada_language_server.exe'
end

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'ada' },
    -- *.gpr and *.adc would be nice to have here
    root_dir = util.root_pattern('Makefile', '.git'),
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/AdaCore/ada_language_server/master/integration/vscode/ada/package.json',
    description = [[
https://github.com/AdaCore/ada_language_server

Installation instructions can be found [here](https://github.com/AdaCore/ada_language_server#Install).

Can be configured by passing a "settings" object to `als.setup{}`:

```lua
require('lspconfig').als.setup{
    settings = {
      ada = {
        projectFile = "project.gpr";
        scenarioVariables = { ... };
      }
    }
}
```
]],
    default_config = {
      root_dir = [[util.root_pattern("Makefile", ".git")]],
    },
  },
}
