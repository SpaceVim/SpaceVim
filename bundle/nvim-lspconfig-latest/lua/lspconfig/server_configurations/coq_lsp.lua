local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'coq-lsp' },
    filetypes = { 'coq' },
    root_dir = function(fname)
      return util.root_pattern '_CoqProject'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ejgallego/coq-lsp/
]],
  },
}
