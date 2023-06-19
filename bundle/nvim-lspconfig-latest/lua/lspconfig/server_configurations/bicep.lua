local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'bicep' },
    root_dir = util.find_git_ancestor,
    init_options = {},
  },
  docs = {
    description = [=[
https://github.com/azure/bicep
Bicep language server

Bicep language server can be installed by downloading and extracting a release of bicep-langserver.zip from [Bicep GitHub releases](https://github.com/Azure/bicep/releases).

Bicep language server requires the [dotnet-sdk](https://dotnet.microsoft.com/download) to be installed.

Neovim does not have built-in support for the bicep filetype which is required for lspconfig to automatically launch the language server.

Filetype detection can be added via an autocmd:
```lua
vim.cmd [[ autocmd BufNewFile,BufRead *.bicep set filetype=bicep ]]
```

**By default, bicep language server does not have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path. You must add the following to your init.vim or init.lua to set `cmd` to the absolute path ($HOME and ~ are not expanded) of the unzipped run script or binary.

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
]=],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
