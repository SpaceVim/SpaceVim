local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'reason-language-server' },
    filetypes = { 'reason' },
    root_dir = util.root_pattern('bsconfig.json', '.git'),
  },
  docs = {
    description = [[
Reason language server

You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.
]],
  },
}
