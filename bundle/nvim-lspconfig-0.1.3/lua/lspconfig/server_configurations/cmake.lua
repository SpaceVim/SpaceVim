local util = require 'lspconfig.util'

local root_files = { 'CMakeLists.txt', 'cmake' }
return {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
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
      root_dir = [[root_pattern(".git", "compile_commands.json", "build")]],
    },
  },
}
