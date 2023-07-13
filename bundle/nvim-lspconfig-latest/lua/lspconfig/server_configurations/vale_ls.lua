local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vale-ls' },
    filetypes = { 'markdown', 'text' },
    root_dir = util.root_pattern '.vale.ini',
  },
  docs = {
    description = [[
https://github.com/errata-ai/vale-ls

An implementation of the Language Server Protocol (LSP) for the Vale command-line tool.
]],
  },
}
