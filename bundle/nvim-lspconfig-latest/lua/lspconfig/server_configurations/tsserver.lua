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
    root_dir = util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git'),
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

### Vue support

As of 2.0.0, Volar no longer supports TypeScript itself. Instead, a plugin
adds Vue support to this language server.

*IMPORTANT*: It is crucial to ensure that `@vue/typescript-plugin` and `volar `are of identical versions.

```lua
require'lspconfig'.tsserver.setup{
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
        languages = {"javascript", "typescript", "vue"},
      },
    },
  },
  filetypes = {
    "javascript",
    "typescript",
    "vue",
  },
}

-- You must make sure volar is setup
-- e.g. require'lspconfig'.volar.setup{}
-- See volar's section for more information
```

`location` MUST be defined. If the plugin is installed in `node_modules`,
`location` can have any value.

`languages` must include `vue` even if it is listed in `filetypes`.

`filetypes` is extended here to include Vue SFC.
]],
    default_config = {
      root_dir = [[root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")]],
    },
  },
}
