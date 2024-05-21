local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_dir = function(fname)
      return util.root_pattern('go.work', 'go.mod', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://templ.guide

The official language server for the templ HTML templating language.
]],
    default_config = {
      root_dir = [[root_pattern('go.work', 'go.mod', '.git')]],
    },
  },
}
