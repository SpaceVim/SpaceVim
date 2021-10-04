local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'graphql'
local bin_name = 'graphql-lsp'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, 'server', '-m', 'stream' },
    filetypes = { 'graphql' },
    root_dir = util.root_pattern('.git', '.graphqlrc*', '.graphql.config.*'),
  },

  docs = {
    description = [[
https://github.com/graphql/graphiql/tree/main/packages/graphql-language-service-cli

`graphql-lsp` can be installed via `npm`:

```sh
npm install -g graphql-language-service-cli
```
]],
    default_config = {
      root_dir = [[root_pattern('.git', '.graphqlrc*', '.graphql.config.*')]],
    },
  },
}
