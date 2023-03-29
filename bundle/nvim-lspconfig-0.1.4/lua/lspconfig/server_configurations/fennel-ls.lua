local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fennel-ls' },
    filetypes = { 'fennel' },
    root_dir = function(dir)
      return util.find_git_ancestor(dir)
    end,
    settings = {},
  },
  docs = {
    description = [[
https://sr.ht/~xerool/fennel-ls/

A language server for fennel.
]],
  },
}
