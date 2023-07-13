local util = require 'lspconfig.util'
local bin_name = 'scheme-langserver'
local cmd = { bin_name }
local root_files = {
  'Akku.manifest',
  '.git',
}

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'scheme' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ufo5260987423/scheme-langserver
`scheme-langserver`, a language server protocol implementation for scheme.
And for nvim user, please add .sls to scheme file extension list.
]],
  },
}
