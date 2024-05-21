local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'gdshader-lsp', '--stdio' },
    filetypes = { 'gdshader', 'gdshaderinc' },
    root_dir = util.root_pattern 'project.godot',
  },
  docs = {
    description = [[
https://github.com/godofavacyn/gdshader-lsp

A language server for the Godot Shading language.
]],
  },
}
