local util = require 'lspconfig.util'

-- pass 0 as the first argument to use STDIN/STDOUT for communication
local cmd = { 'smithy-language-server', '0' }

local root_files = {
  'smithy-build.json',
  'build.gradle',
  'build.gradle.kts',
  '.git',
}

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'smithy' },
    single_file_support = true,
    root_dir = util.root_pattern(unpack(root_files)),
  },
  docs = {
    description = [[
https://github.com/awslabs/smithy-language-server

`Smithy Language Server`, A Language Server Protocol implementation for the Smithy IDL
]],
    default_config = {
      root_dir = [[root_pattern("smithy-build.json", "build.gradle", "build.gradle.kts", ".git")]],
    },
  },
}
