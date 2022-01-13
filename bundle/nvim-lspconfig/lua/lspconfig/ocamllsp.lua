local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local language_id_of = {
  menhir = 'ocaml.menhir',
  ocaml = 'ocaml',
  ocamlinterface = 'ocaml.interface',
  ocamllex = 'ocaml.ocamllex',
  reason = 'reason',
}

local get_language_id = function(_, ftype)
  return language_id_of[ftype]
end

configs.ocamllsp = {
  default_config = {
    cmd = { 'ocamllsp' },
    filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason' },
    root_dir = util.root_pattern('*.opam', 'esy.json', 'package.json', '.git'),
    get_language_id = get_language_id,
  },
  docs = {
    description = [[
https://github.com/ocaml/ocaml-lsp

`ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).

To install the lsp server in a particular opam switch:
```sh
opam pin add ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git
opam install ocaml-lsp-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.opam", "esy.json", "package.json", ".git")]],
    },
  },
}
