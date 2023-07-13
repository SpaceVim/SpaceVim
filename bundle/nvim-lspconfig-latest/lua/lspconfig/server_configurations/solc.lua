local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'solc', '--lsp' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern('hardhat.config.*', '.git'),
  },
  docs = {
    description = [[
https://docs.soliditylang.org/en/latest/installing-solidity.html

solc is the native language server for the Solidity language.
]],
    default_config = {
      root_dir = [[root_pattern('hardhat.config.*', '.git')]],
    },
  },
}
