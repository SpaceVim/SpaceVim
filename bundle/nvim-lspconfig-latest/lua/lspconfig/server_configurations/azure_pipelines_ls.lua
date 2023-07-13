local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'azure-pipelines-language-server', '--stdio' },
    filetypes = { 'yaml' },
    root_dir = util.root_pattern 'azure-pipelines.yml',
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/microsoft/azure-pipelines-language-server

An Azure Pipelines language server

`azure-pipelines-ls` can be installed via `npm`:

```sh
npm install -g azure-pipelines-language-server
```

By default `azure-pipelines-ls` will only work in files named `azure-pipelines.yml`, this can be changed by providing additional settings like so:
```lua
require("lspconfig").azure_pipelines_ls.setup {
  ... -- other configuration for setup {}
  settings = {
      yaml = {
          schemas = {
              ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
                  "/azure-pipeline*.y*l",
                  "/*.azure*",
                  "Azure-Pipelines/**/*.y*l",
                  "Pipelines/*.y*l",
              },
          },
      },
  },
}
```
The Azure Pipelines LSP is a fork of `yaml-language-server` and as such the same settings can be passed to it as `yaml-language-server`.
]],
  },
}
