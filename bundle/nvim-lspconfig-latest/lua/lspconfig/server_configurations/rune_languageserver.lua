local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rune-languageserver' },
    filetypes = { 'rune' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://crates.io/crates/rune-languageserver

A language server for the [Rune](https://rune-rs.github.io/) Language,
an embeddable dynamic programming language for Rust
        ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
