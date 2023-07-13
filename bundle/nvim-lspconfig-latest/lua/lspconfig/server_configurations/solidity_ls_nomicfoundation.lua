local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nomicfoundation-solidity-language-server', '--stdio' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('.git', 'package.json'),
  },
  docs = {
    description = [[
https://github.com/NomicFoundation/hardhat-vscode/blob/development/server/README.md

npm install -g @ignored/solidity-language-server

A language server for the Solidity programming language, built by the Nomic Foundation for the Ethereum community.
]],
    default_config = {
      root_dir = [[root_pattern(".git", "package.json")]],
    },
  },
}
