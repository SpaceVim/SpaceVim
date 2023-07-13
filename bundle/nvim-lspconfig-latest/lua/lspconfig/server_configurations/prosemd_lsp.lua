local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'prosemd-lsp', '--stdio' },
    filetypes = { 'markdown' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kitten/prosemd-lsp

An experimental LSP for Markdown.

Please see the manual installation instructions: https://github.com/kitten/prosemd-lsp#manual-installation
]],
    default_config = {
      root_dir = util.find_git_ancestor,
    },
  },
}
