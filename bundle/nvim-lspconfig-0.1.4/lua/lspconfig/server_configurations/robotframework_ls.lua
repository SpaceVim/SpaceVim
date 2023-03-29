local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'robotframework_ls' },
    filetypes = { 'robot' },
    root_dir = function(fname)
      return util.root_pattern('robotidy.toml', 'pyproject.toml')(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/robocorp/robotframework-lsp

Language Server Protocol implementation for Robot Framework.
]],
    default_config = {
      root_dir = "util.root_pattern('robotidy.toml', 'pyproject.toml')(fname) or util.find_git_ancestor(fname)",
    },
  },
}
