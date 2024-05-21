local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
    root_dir = util.root_pattern('package.json', '.git'),
    single_file_support = true,
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
