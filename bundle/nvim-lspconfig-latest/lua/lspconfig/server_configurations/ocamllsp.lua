local util = require 'lspconfig.util'

local language_id_of = {
  menhir = 'ocaml.menhir',
  ocaml = 'ocaml',
  ocamlinterface = 'ocaml.interface',
  ocamllex = 'ocaml.ocamllex',
  reason = 'reason',
  dune = 'dune',
}

local get_language_id = function(_, ftype)
  return language_id_of[ftype]
end

return {
  default_config = {
    cmd = { 'ocamllsp' },
    filetypes = { 'ocaml', 'ocaml.menhir', 'ocaml.interface', 'ocaml.ocamllex', 'reason', 'dune' },
    root_dir = util.root_pattern('*.opam', 'esy.json', 'package.json', '.git', 'dune-project', 'dune-workspace'),
    get_language_id = get_language_id,
  },
  docs = {
    description = [[
https://github.com/ocaml/ocaml-lsp

`ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).

To install the lsp server in a particular opam switch:
```sh
opam install ocaml-lsp-server
```
    ]],
    default_config = {
      root_dir = [[root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace")]],
    },
  },
}
