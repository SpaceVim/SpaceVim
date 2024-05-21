local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rome', 'lsp-proxy' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'json',
      'typescript',
      'typescript.tsx',
      'typescriptreact',
    },
    root_dir = function(fname)
      return util.find_package_json_ancestor(fname)
        or util.find_node_modules_ancestor(fname)
        or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://rome.tools

Language server for the Rome Frontend Toolchain.

(Unmaintained, use [Biome](https://biomejs.dev/blog/annoucing-biome) instead.)

```sh
npm install [-g] rome
```
]],
    default_config = {
      root_dir = [[root_pattern('package.json', 'node_modules', '.git')]],
    },
  },
}
