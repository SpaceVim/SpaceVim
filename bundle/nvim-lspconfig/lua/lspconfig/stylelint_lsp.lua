local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.stylelint_lsp = {
  default_config = {
    cmd = { 'stylelint-lsp', '--stdio' },
    filetypes = {
      'css',
      'less',
      'scss',
      'sugarss',
      'vue',
      'wxss',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    root_dir = util.root_pattern('.stylelintrc', 'package.json'),
    settings = {},
  },
  docs = {
    package_json = 'https://raw.githubusercontent.com/bmatcuk/coc-stylelintplus/master/package.json',
    description = [[
https://github.com/bmatcuk/stylelint-lsp

`stylelint-lsp` can be installed via `npm`:

```sh
npm i -g stylelint-lsp
```

Can be configured by passing a `settings.stylelintplus` object to `stylelint_lsp.setup`:

```lua
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
    }
  }
}
```
]],
    default_config = {
      root_dir = [[ root_pattern('.stylelintrc', 'package.json') ]],
    },
  },
}
