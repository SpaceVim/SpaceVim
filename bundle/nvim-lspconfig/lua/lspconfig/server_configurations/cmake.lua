local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cmake-language-server' },
    filetypes = { 'cmake' },
    root_dir = util.root_pattern('.git', 'compile_commands.json', 'build'),
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
      root_dir = [[root_pattern(".git", "compile_commands.json", "build") or dirname]],
    },
  },
}
