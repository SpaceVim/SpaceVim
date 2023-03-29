local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'asm-lsp' },
    filetypes = { 'asm', 'vmasm' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/bergercookie/asm-lsp

Language Server for GAS/GO Assembly

`asm-lsp` can be installed via cargo:
cargo install asm-lsp
]],
  },
}
