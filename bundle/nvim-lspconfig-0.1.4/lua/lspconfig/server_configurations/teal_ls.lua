local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'teal-language-server',
      -- use this to enable logging in /tmp/teal-language-server.log
      -- "logging=on",
    },
    filetypes = {
      'teal',
      -- "lua", -- Also works for lua, but you may get type errors that cannot be resolved within lua itself
    },
    root_dir = util.root_pattern('tlconfig.lua', '.git'),
  },
  docs = {
    description = [[
https://github.com/teal-language/teal-language-server

Install with:
```
luarocks install --dev teal-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("tlconfig.lua", ".git")]],
    },
  },
}
