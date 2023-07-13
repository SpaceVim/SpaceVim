local util = require 'lspconfig.util'

local port = os.getenv 'GDScript_Port' or '6005'
local cmd = { 'nc', 'localhost', port }

if vim.fn.has 'nvim-0.8' == 1 then
  cmd = vim.lsp.rpc.connect('127.0.0.1', port)
end

return {
  default_config = {
    cmd = cmd,
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
