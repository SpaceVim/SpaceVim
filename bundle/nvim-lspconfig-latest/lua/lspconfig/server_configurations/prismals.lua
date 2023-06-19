local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'prisma-language-server', '--stdio' },
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
