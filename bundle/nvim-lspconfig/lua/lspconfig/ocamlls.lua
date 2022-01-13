local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'ocamlls'
local bin_name = 'ocaml-language-server'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'ocaml', 'reason' },
    root_dir = util.root_pattern('*.opam', 'esy.json', 'package.json'),
  },
  docs = {
    description = [[
https://github.com/ocaml-lsp/ocaml-language-server

`ocaml-language-server` can be installed via `npm`
```sh
npm install -g ocaml-langauge-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.opam", "esy.json", "package.json")]],
    },
  },
}
