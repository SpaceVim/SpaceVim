local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.gdscript = {
  default_config = {
    cmd = { 'nc', 'localhost', '6008' },
    filetypes = { 'gd', 'gdscript', 'gdscript3' },
    root_dir = util.root_pattern('project.godot', '.git'),
  },
  docs = {
    description = [[
https://github.com/godotengine/godot

Language server for GDScript, used by Godot Engine.
]],
    default_config = {
      root_dir = [[util.root_pattern("project.godot", ".git")]],
    },
  },
}

-- vim:et ts=2 sw=2
