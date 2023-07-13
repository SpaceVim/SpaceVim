local util = require 'lspconfig.util'

return {
  default_config = {
    init_options = { hostInfo = 'neovim' },
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    root_dir = function(fname)
      return util.root_pattern 'tsconfig.json'(fname)
        or util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/typescript-language-server/typescript-language-server

`typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
```sh
npm install -g typescript typescript-language-server
```

To configure typescript language server, add a
[`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
[`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
project.

Here's an example that disables type checking in JavaScript files.

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "es6",
    "checkJs": false
  },
  "exclude": [
    "node_modules"
  ]
}
```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
    },
  },
}
