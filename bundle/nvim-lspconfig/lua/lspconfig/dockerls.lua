local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'dockerls'
local bin_name = 'docker-langserver'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'Dockerfile', 'dockerfile' },
    root_dir = util.root_pattern 'Dockerfile',
  },
  docs = {
    description = [[
https://github.com/rcjsuen/dockerfile-language-server-nodejs

`docker-langserver` can be installed via `npm`:
```sh
npm install -g dockerfile-language-server-nodejs
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Dockerfile")]],
    },
  },
}

-- vim:et ts=2 sw=2
