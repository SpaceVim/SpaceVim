local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gleam', 'lsp' },
    filetypes = { 'gleam' },
    root_dir = function(fname)
      return util.root_pattern('gleam.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/gleam-lang/gleam

A language server for Gleam Programming Language.
[Installation](https://gleam.run/getting-started/installing/)

It can be i
]],
    default_config = {
      cmd = { 'gleam', 'lsp' },
      root_dir = [[root_pattern("gleam.toml", ".git")]],
    },
  },
}
