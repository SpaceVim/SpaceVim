local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'unocss-language-server', '--stdio' },
    filetypes = {
      'html',
      'javascriptreact',
      'rescript',
      'typescriptreact',
      'vue',
      'svelte',
    },
    root_dir = function(fname)
      return util.root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/xna00/unocss-language-server

UnoCSS Language Server can be installed via npm:
```sh
npm i unocss-language-server -g
```
]],
    default_config = {
      root_dir = [[root_pattern('unocss.config.js', 'unocss.config.ts', 'uno.config.js', 'uno.config.ts')]],
    },
  },
}
