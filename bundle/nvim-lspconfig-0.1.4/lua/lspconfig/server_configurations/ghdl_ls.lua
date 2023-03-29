local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ghdl-ls' },
    filetypes = { 'vhdl' },
    root_dir = function(fname)
      return util.root_pattern 'hdl-prj.json'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/ghdl/ghdl-language-server

A language server for VHDL, using ghdl as its backend.

`ghdl-ls` is part of pyghdl, for installation instructions see
[the upstream README](https://github.com/ghdl/ghdl/tree/master/pyGHDL/lsp).
]],
  },
}
