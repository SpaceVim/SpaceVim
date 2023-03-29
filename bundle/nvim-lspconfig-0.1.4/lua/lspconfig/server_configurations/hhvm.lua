local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'hh_client', 'lsp' },
    filetypes = { 'php', 'hack' },
    root_dir = util.root_pattern '.hhconfig',
  },
  docs = {
    description = [[
Language server for programs written in Hack
https://hhvm.com/
https://github.com/facebook/hhvm
See below for how to setup HHVM & typechecker:
https://docs.hhvm.com/hhvm/getting-started/getting-started
    ]],
    default_config = {
      root_dir = [[root_pattern(".hhconfig")]],
    },
  },
}
