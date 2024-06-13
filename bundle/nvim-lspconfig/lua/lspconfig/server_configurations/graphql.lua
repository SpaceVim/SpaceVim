local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'graphql-lsp', 'server', '-m', 'stream' },
    filetypes = { 'graphql' },
    root_dir = util.root_pattern('.git', '.graphqlrc*', '.graphql.config.*', 'graphql.config.*'),
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
