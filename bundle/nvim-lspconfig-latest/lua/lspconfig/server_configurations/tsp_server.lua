local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tsp-server', '--stdio' },
    filetypes = { 'typespec' },
    root_dir = util.root_pattern('tspconfig.yaml', '.git'),
  },
  docs = {
    description = [[
https://github.com/microsoft/typespec

The language server for TypeSpec, a language for defining cloud service APIs and shapes.

`tsp-server` can be installed together with the typespec compiler via `npm`:
```sh
npm install -g @typespec/compiler
```
]],
    default_config = {
      root_dir = [[util.root_pattern("tspconfig.yaml", ".git")]],
    },
  },
}
