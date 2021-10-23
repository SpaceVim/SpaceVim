local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.cmake = {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = function(fname)
      return util.root_pattern('.git', 'compile_commands.json', 'build')(fname) or util.path.dirname(fname)
    end,
    init_options = {
      buildDirectory = 'build',
    },
  },
  docs = {
    description = [[
https://github.com/regen100/cmake-language-server

CMake LSP Implementation
]],
    default_config = {
      root_dir = [[root_pattern(".git", "compile_commands.json", "build") or dirname]],
    },
  },
}
