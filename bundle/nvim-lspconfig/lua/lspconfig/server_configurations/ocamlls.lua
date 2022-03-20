local util = require 'lspconfig.util'

local bin_name = 'ocaml-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end
return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ocaml', 'reason' },
    root_dir = util.root_pattern('*.opam', 'esy.json', 'package.json'),
  },
  docs = {
    description = [[
https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `npm`
```sh
npm install -g ocaml-language-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.opam", "esy.json", "package.json")]],
    },
  },
}
