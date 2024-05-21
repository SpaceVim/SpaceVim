local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'circom-lsp' },
    filetypes = { 'circom' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
[Circom Language Server](https://github.com/rubydusa/circom-lsp)

`circom-lsp`, the language server for the Circom language.
    ]],
  },
}
