local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html', 'templ' },
    root_dir = util.root_pattern('package.json', '.git'),
    single_file_support = true,
    settings = {},
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { 'html', 'css', 'javascript' },
    },
  },
  docs = {
    description = [[
https://github.com/hrsh7th/vscode-langservers-extracted

`vscode-html-language-server` can be installed via `npm`:
```sh
npm i -g vscode-langservers-extracted
```

Neovim does not currently include built-in snippets. `vscode-html-language-server` only provides completions when snippet support is enabled.
To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.

The code-formatting feature of the lsp can be controlled with the `provideFormatter` option.

```lua
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
}
```
]],
  },
}
