local util = require 'lspconfig.util'

local bin_name = 'prisma-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
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
npm install -g @prisma/language-server

'prismals, a language server for the prisma javascript and typescript orm'
]],
    default_config = {
      root_dir = [[root_pattern(".git", "package.json")]],
    },
  },
}
