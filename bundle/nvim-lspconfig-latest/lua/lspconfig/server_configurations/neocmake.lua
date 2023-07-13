local util = require 'lspconfig.util'

local root_files = { '.git', 'build', 'cmake' }
return {
  default_config = {
    cmd = { 'neocmakelsp', '--stdio' },
    filetypes = { 'cmake' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Decodetalkers/neocmakelsp

CMake LSP Implementation
]],
    default_config = {
      root_dir = [[root_pattern('.git', 'cmake')]],
    },
  },
}
