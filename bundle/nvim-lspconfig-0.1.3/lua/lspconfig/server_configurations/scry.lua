local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'scry' },
    filetypes = { 'crystal' },
    root_dir = function(fname)
      return util.root_pattern 'shard.yml'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/crystal-lang-tools/scry

Crystal language server.
]],
    default_config = {
      root_dir = [[root_pattern('shard.yml', '.git')]],
    },
  },
}
