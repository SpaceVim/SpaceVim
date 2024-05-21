local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'Swift-MesonLSP', '--lsp' },
    filetypes = { 'meson' },
    root_dir = util.root_pattern('meson_options.txt', 'meson.options', '.git'),
  },
  docs = {
    description = [[
https://github.com/JCWasmx86/Swift-MesonLSP

Meson language server written in Swift
]],
    default_config = {
      root_dir = [[util.root_pattern("meson_options.txt", "meson.options", ".git")]],
    },
  },
}
