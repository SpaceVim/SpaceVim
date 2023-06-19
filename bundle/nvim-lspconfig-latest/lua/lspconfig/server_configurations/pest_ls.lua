local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pest-language-server' },
    filetypes = { 'pest' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pest-parser/pest-ide-tools

Language server for pest grammars.
]],
  },
}
