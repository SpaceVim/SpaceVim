local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fortls' },
    filetypes = { 'fortran' },
    root_dir = function(fname)
      return util.root_pattern '.fortls'(fname) or util.find_git_ancestor(fname)
    end,
    settings = {
      nthreads = 1,
    },
  },
  docs = {
    description = [[
https://github.com/hansec/fortran-language-server

Fortran Language Server for the Language Server Protocol
    ]],
    default_config = {
      root_dir = [[root_pattern(".fortls")]],
    },
  },
}
