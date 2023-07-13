local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ocaml-language-server', '--stdio' },
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
