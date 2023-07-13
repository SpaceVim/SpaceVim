local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nxls', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_dir = util.root_pattern('nx.json', '.git'),
  },
  docs = {
    description = [[
https://github.com/nrwl/nx-console/tree/master/apps/nxls

nxls, a language server for Nx Workspaces

`nxls` can be installed via `npm`:
```sh
npm i -g nxls
```
]],
    default_config = {
      root_dir = [[util.root_pattern]],
    },
  },
}
