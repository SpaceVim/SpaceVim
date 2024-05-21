local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'biome', 'lsp-proxy' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'jsonc',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
      'astro',
      'svelte',
      'vue',
    },
    root_dir = util.root_pattern('biome.json', 'biome.jsonc'),
    single_file_support = false,
  },
  docs = {
    description = [[
https://biomejs.dev

Toolchain of the web. [Successor of Rome](https://biomejs.dev/blog/annoucing-biome).

```sh
npm install [-g] @biomejs/biome
```
]],
    default_config = {
      root_dir = [[root_pattern('biome.json', 'biome.jsonc')]],
    },
  },
}
