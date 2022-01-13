local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'psalm'
local bin_name = 'psalm-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'php' },
    root_dir = util.root_pattern('psalm.xml', 'psalm.xml.dist'),
  },
  docs = {
    description = [[
https://github.com/vimeo/psalm

Can be installed with composer.
```sh
composer global require vimeo/psalm
```
]],
    default_config = {
      cmd = { 'psalm-language-server' },
      root_dir = [[root_pattern("psalm.xml", "psalm.xml.dist")]],
    },
  },
}
