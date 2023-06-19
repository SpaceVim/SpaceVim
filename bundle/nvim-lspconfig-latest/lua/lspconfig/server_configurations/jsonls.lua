local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
      provideFormatter = true,
    },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    -- this language server config is in VSCode built-in package.json
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

vscode-json-language-server, a language server for JSON and JSON schema

`vscode-json-language-server` can be installed via `npm`:
```sh
npm i -g vscode-langservers-extracted
```

Neovim does not currently include built-in snippets. `vscode-json-language-server` only provides completions when snippet support is enabled. To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.

```lua
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.jsonls.setup {
  capabilities = capabilities,
}
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
