local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cuelsp' },
    filetypes = { 'cue' },
    root_dir = function(fname)
      return util.root_pattern('cue.mod', '.git')(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dagger/cuelsp

Dagger's lsp server for cuelang.
]],
    default_config = {
      root_dir = [[root_pattern("cue.mod", ".git")]],
    },
  },
}
