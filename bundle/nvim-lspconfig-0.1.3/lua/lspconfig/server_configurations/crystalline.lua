local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'crystalline' },
    filetypes = { 'crystal' },
    root_dir = util.root_pattern 'shard.yml' or util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elbywan/crystalline

Crystal language server.
]],
    default_config = {
      root_dir = [[root_pattern('shard.yml', '.git')]],
    },
  },
}
