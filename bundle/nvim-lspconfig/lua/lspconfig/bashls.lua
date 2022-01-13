local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'bashls'

configs[server_name] = {
  default_config = {
    cmd = { 'bash-language-server', 'start' },
    cmd_env = {
      -- Prevent recursive scanning which will cause issues when opening a file
      -- directly in the home directory (e.g. ~/foo.sh).
      --
      -- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
      GLOB_PATTERN = vim.env.GLOB_PATTERN or '*@(.sh|.inc|.bash|.command)',
    },
    filetypes = { 'sh' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.
]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
