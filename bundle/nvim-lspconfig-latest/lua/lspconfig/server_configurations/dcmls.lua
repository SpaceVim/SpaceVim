local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dcm', 'start-server', '--client=neovim' },
    filetypes = { 'dart' },
    root_dir = util.root_pattern 'pubspec.yaml',
  },
  docs = {
    description = [[
https://dcm.dev/

Language server for DCM analyzer.
]],
    default_config = {
      root_dir = [[root_pattern("pubspec.yaml")]],
    },
  },
}
