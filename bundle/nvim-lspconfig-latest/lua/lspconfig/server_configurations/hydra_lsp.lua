local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'hydra-lsp' },
    filetypes = { 'yaml' },
    root_dir = util.root_pattern '.git',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Retsediv/hydra-lsp

LSP for Hydra Python package config files.
]],
    default_config = {
      root_dir = [[util.root_pattern '.git']],
    },
  },
}
