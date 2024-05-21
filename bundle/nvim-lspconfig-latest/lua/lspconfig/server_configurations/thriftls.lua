local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'thriftls' },
    filetypes = { 'thrift' },
    root_dir = util.root_pattern '.thrift',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/joyme123/thrift-ls

you can install thriftls by mason or download binary here: https://github.com/joyme123/thrift-ls/releases
]],
    default_config = {
      root_dir = [[root_pattern(".thrift")]],
    },
  },
}
