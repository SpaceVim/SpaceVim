local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nu', '--lsp' },
    filetypes = { 'nu' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nushell/nushell

Nushell built-in language server.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
