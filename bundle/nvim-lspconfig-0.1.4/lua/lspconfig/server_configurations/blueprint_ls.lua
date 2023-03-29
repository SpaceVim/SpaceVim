local util = require 'lspconfig.util'

local bin_name = 'blueprint-compiler'
local cmd = { bin_name, 'lsp' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'start' }
end

return {
  default_config = {
    cmd = cmd,
    cmd_env = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      GLOB_PATTERN = vim.env.GLOB_PATTERN or '*@(.blp)',
    },
    filetypes = { 'blueprint' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://gitlab.gnome.org/jwestman/blueprint-compiler

`blueprint-compiler` can be installed via your system package manager.

Language server for the blurprint markup language, written in python and part
of the blueprint-compiler.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
