local util = require 'lspconfig.util'

return {
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
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/mads-hartmann/bash-language-server

Language server for bash, written using tree sitter in typescript.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
