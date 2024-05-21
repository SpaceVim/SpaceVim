local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'roc_language_server' },
    filetypes = { 'roc' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/roc-lang/roc/tree/main/crates/language_server#roc_language_server

The built-in language server for the Roc programming language.
[Installation](https://github.com/roc-lang/roc/tree/main/crates/language_server#installing)
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
