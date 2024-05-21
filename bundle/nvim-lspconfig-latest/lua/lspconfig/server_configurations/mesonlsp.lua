local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mesonlsp', '--lsp' },
    filetypes = { 'meson' },
    root_dir = util.root_pattern('meson_options.txt', 'meson.options', '.git'),
  },
  docs = {
    description = [[
https://github.com/JCWasmx86/mesonlsp

An unofficial, unendorsed language server for meson written in C++
]],
    default_config = {
      root_dir = [[util.root_pattern("meson_options.txt", "meson.options", ".git")]],
    },
  },
}
