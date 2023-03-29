local util = require 'lspconfig.util'

local bin_name = 'nxls'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
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
