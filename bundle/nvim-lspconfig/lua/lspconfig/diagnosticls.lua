local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'diagnosticls'
local bin_name = 'diagnostic-languageserver'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = {},
    root_dir = util.path.dirname,
  },
  docs = {
    description = [[
https://github.com/iamcco/diagnostic-languageserver

Diagnostic language server integrate with linters.
]],
    default_config = {
      filetypes = 'Empty by default, override to add filetypes',
      root_dir = "Vim's starting directory",
      init_options = 'Configuration from https://github.com/iamcco/diagnostic-languageserver#config--document',
    },
  },
}
