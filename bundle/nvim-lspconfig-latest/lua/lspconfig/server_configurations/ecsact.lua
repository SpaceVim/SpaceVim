local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ecsact_lsp_server', '--stdio' },
    filetypes = { 'ecsact' },
    root_dir = util.root_pattern '.git',
    single_file_support = true,
  },

  docs = {
    description = [[
https://github.com/ecsact-dev/ecsact_lsp_server

Language server for Ecsact.

The default cmd assumes `ecsact_lsp_server` is in your PATH. Typically from the
Ecsact SDK: https://ecsact.dev/start
]],
  },
}
