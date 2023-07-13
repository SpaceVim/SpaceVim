local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pact-lsp' },
    filetypes = { 'pact' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/kadena-io/pact-lsp

The Pact language server
    ]],
  },
}
