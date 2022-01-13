local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local server_name = 'bicep'

configs[server_name] = {
  default_config = {
    filetypes = { 'bicep' },
    root_dir = util.root_pattern '.git',
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/azure/bicep
Bicep language server

Bicep language server can be installed by downloading and extracting a release of bicep-langserver.zip from [Bicep GitHub releases](https://github.com/Azure/bicep/releases).

Bicep language server requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

**By default, bicep language server doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of the unzipped run script or binary.

```lua
local bicep_lsp_bin = "/path/to/bicep-langserver/Bicep.LangServer.dll"
require'lspconfig'.bicep.setup{
    cmd = { "dotnet", bicep_lsp_bin };
    ...
}
```

To download the latest release and place in /usr/local/bin/bicep-langserver:
```bash
(cd $(mktemp -d) \
    && curl -fLO https://github.com/Azure/bicep/releases/latest/download/bicep-langserver.zip \
    && rm -rf /usr/local/bin/bicep-langserver \
    && unzip -d /usr/local/bin/bicep-langserver bicep-langserver.zip)
```
]],
  },
}
