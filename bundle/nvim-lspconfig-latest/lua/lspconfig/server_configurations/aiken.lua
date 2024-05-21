local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'aiken', 'lsp' },
    filetypes = { 'aiken' },
    root_dir = function(fname)
      return util.root_pattern('aiken.toml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/aiken-lang/aiken

A language server for Aiken Programming Language.
[Installation](https://aiken-lang.org/installation-instructions)

It can be i
]],
    default_config = {
      cmd = { 'aiken', 'lsp' },
      root_dir = [[root_pattern("aiken.toml", ".git")]],
    },
  },
}
