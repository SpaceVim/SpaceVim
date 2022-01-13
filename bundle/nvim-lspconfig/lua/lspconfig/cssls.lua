local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'cssls'
local bin_name = 'vscode-css-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_dir = function(fname)
      return util.root_pattern('package.json', '.git')(fname) or util.path.dirname(fname)
    end,
    settings = {
      css = { validate = true },
      scss = { validate = true },
      less = { validate = true },
    },
  },
  docs = {
    description = [[

https://github.com/hrsh7th/vscode-langservers-extracted

`css-languageserver` can be installed via `npm`:

```sh
npm i -g vscode-langservers-extracted
```

Neovim does not currently include built-in snippets. `vscode-css-language-server` only provides completions when snippet support is enabled. To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.

```lua
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
  capabilities = capabilities,
}
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", ".git") or bufdir]],
    },
  },
}
