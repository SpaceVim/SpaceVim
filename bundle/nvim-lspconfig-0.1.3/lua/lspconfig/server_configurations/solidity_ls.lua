local util = require 'lspconfig.util'

local bin_name = 'solidity-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

return {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('.git', 'package.json'),
  },
  docs = {
    description = [[
npm install -g solidity-language-server

solidity-language-server is a language server for the solidity language ported from the vscode solidity extension
]],
    default_config = {
      root_dir = [[root_pattern(".git", "package.json")]],
    },
  },
}
