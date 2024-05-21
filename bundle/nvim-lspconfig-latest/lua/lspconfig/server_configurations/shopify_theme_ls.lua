local util = require 'lspconfig.util'

local root_files = {
  '.shopifyignore',
  '.theme-check.yml',
  '.theme-check.yaml',
  'shopify.theme.toml',
}

return {
  default_config = {
    cmd = {
      'shopify',
      'theme',
      'language-server',
    },
    filetypes = { 'liquid' },
    root_dir = util.root_pattern(unpack(root_files)),
    settings = {},
  },
  docs = {
    description = [[
https://shopify.dev/docs/api/shopify-cli

[Language Server](https://shopify.dev/docs/themes/tools/cli/language-server) and Theme Check (linter) for Shopify themes.

`shopify` can be installed via npm `npm install -g @shopify/cli`.

```lua
require lspconfig.shopify_theme_ls.setup {}
```

Note: This LSP already includes Theme Check so you don't need to use the `theme_check` server configuration as well.
]],
  },
}
