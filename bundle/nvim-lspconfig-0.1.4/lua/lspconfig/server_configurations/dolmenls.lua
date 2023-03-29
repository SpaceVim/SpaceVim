local util = require 'lspconfig.util'

local bin_name = 'dolmenls'
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end
return {
  default_config = {
    cmd = cmd,
    filetypes = { 'smt2', 'tptp', 'p', 'cnf', 'icnf', 'zf' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/Gbury/dolmen/blob/master/doc/lsp.md

`dolmenls` can be installed via `opam`
```sh
opam install dolmen_lsp
```
    ]],
  },
}
