local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'als' },
    filetypes = { 'agda' },
    root_dir = util.root_pattern('.git', '*.agda-lib'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/agda/agda-language-server

Language Server for Agda.
]],
  },
}
