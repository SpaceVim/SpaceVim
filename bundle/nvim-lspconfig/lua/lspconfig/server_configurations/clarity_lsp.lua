local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'clarity-lsp' },
    filetypes = { 'clar', 'clarity' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
`clarity-lsp` is a language server for the Clarity language. Clarity is a decidable smart contract language that optimizes for predictability and security. Smart contracts allow developers to encode essential business logic on a blockchain.

To learn how to configure the clarity language server, see the [clarity-lsp documentation](https://github.com/hirosystems/clarity-lsp).
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
