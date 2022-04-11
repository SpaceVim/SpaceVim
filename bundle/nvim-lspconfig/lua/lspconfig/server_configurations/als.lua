local util = require 'lspconfig.util'
local bin_name = 'ada_language_server'

if vim.fn.has 'win32' == 1 then
  bin_name = 'ada_language_server.exe'
end

return {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'ada' },
    root_dir = util.root_pattern('Makefile', '.git', '*.gpr', '*.adc'),
  },
  docs = {
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
      root_dir = [[util.root_pattern("Makefile", ".git", "*.gpr", "*.adc")]],
    },
  },
}
