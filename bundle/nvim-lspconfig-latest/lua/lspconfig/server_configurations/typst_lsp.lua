local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'typst-lsp' },
    filetypes = { 'typst' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/nvarner/typst-lsp

Language server for Typst.
    ]],
  },
}
