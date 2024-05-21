local util = require 'lspconfig/util'

return {
  default_config = {
    cmd = { 'earthlyls' },
    filetypes = { 'earthfile' },
    root_dir = util.root_pattern 'Earthfile',
  },
  docs = {
    description = [[
https://github.com/glehmann/earthlyls

A fast language server for earthly.
]],
  },
}
