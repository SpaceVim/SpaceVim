local util = require 'lspconfig.util'

return {
  default_config = {
    init_options = { hostInfo = 'neovim' },
    cmd = { 'custom-elements-languageserver', '--stdio' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
      'html',
    },
    root_dir = function(fname)
      return util.root_pattern 'tsconfig.json'(fname)
        or util.root_pattern('package.json', 'jsconfig.json', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/Matsuuu/custom-elements-language-server

`custom-elements-languageserver` depends on `typescript`. Both packages can be installed via `npm`:
```sh
npm install -g typescript custom-elements-languageserver
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

The best way to utilize the Custom Elements Language Server is to enable the [Custom Elements Manifest](https://github.com/webcomponents/custom-elements-manifest)(CEM) in your project by installing
a CEM generator like one provided by [The Open WC Team](https://github.com/open-wc/custom-elements-manifest/tree/master/packages/analyzer).

Generating a CEM in watch mode will provide you with the best user experience. If your dependencies ship with a Custom Elements Manifest, those will be utilized also.

```
]],
    default_config = {
      root_dir = [[root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")]],
    },
  },
}
