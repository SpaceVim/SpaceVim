local util = require 'lspconfig.util'

local bin_name = 'spectral-language-server'

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'yaml', 'json', 'yml' },
    root_dir = util.root_pattern('.spectral.yaml', '.spectral.yml', '.spectral.json', '.spectral.js'),
    single_file_support = true,
    settings = {
      enable = true,
      run = 'onType',
      validateLanguages = { 'yaml', 'json', 'yml' },
    },
  },
  docs = {
    description = [[
https://github.com/luizcorreia/spectral-language-server
 `A flexible JSON/YAML linter for creating automated style guides, with baked in support for OpenAPI v2 & v3.`

`spectral-language-server` can be installed via `npm`:
```sh
npm i -g spectral-language-server
```
See [vscode-spectral](https://github.com/stoplightio/vscode-spectral#extension-settings) for configuration options.
]],
  },
}
