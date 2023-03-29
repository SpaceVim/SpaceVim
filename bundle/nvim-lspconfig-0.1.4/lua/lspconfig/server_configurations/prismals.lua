local util = require 'lspconfig.util'

local bin_name = 'prisma-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'prisma' },
    settings = {
      prisma = {
        prismaFmtBinPath = '',
      },
    },
    root_dir = util.root_pattern('.git', 'package.json'),
  },
  docs = {
    description = [[
Language Server for the Prisma JavaScript and TypeScript ORM

`@prisma/language-server` can be installed via npm
```sh
npm install -g @prisma/language-server
```
]],
    default_config = {
      root_dir = [[root_pattern(".git", "package.json")]],
    },
  },
}
