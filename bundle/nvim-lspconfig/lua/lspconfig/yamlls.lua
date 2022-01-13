local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'yamlls'
local bin_name = 'yaml-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'yaml' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/redhat-developer/vscode-yaml/master/package.json',
    description = [[
https://github.com/redhat-developer/yaml-language-server

`yaml-language-server` can be installed via `yarn`:
```sh
yarn global add yaml-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern(".git") or dirname]],
    },
  },
}
