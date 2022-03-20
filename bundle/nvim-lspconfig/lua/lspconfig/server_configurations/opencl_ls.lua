local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'opencl-language-server' },
    filetypes = { 'opencl' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/Galarius/opencl-language-server

Build instructions can be found [here](https://github.com/Galarius/opencl-language-server/blob/main/_dev/build.md).

Prebuilt binaries are available for Linux, macOS and Windows [here](https://github.com/Galarius/opencl-language-server/releases).
]],
    default_config = {
      root_dir = [[util.root_pattern(".git")]],
    },
  },
}
