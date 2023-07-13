local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'hdl_checker', '--lsp' },
    filetypes = { 'vhdl', 'verilog', 'systemverilog' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/suoto/hdl_checker
Language server for hdl-checker.
Install using: `pip install hdl-checker --upgrade`
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
