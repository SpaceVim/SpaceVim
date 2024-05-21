local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'yang-language-server' },
    filetypes = { 'yang' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/TypeFox/yang-lsp

A Language Server for the YANG data modeling language.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
