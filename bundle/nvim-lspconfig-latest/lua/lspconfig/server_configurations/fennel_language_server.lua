local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fennel-language-server' },
    filetypes = { 'fennel' },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/rydesun/fennel-language-server

Fennel language server protocol (LSP) support.
]],
  },
}
