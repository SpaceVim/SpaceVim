local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'theme_check'
local bin_name = 'theme-check-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'liquid' },
    root_dir = util.root_pattern '.theme-check.yml',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/Shopify/shopify-cli

`theme-check-language-server` is bundled with `shopify-cli` or it can also be installed via

https://github.com/Shopify/theme-check#installation

**NOTE:**
If installed via Homebrew, `cmd` must be set to 'theme-check-liquid-server'

```lua
require lspconfig.theme_check.setup {
  cmd = { 'theme-check-liquid-server' }
}
```

]],
  },
}
