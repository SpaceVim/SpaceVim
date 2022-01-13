local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.dhall_lsp_server = {
  default_config = {
    cmd = { 'dhall-lsp-server' },
    filetypes = { 'dhall' },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
    docs = {
      description = [[
https://github.com/dhall-lang/dhall-haskell/tree/master/dhall-lsp-server

language server for dhall

`dhall-lsp-server` can be installed via cabal:
```sh
cabal install dhall-lsp-server
```
prebuilt binaries can be found [here](https://github.com/dhall-lang/dhall-haskell/releases).
]],
      default_config = {
        root_dir = [[root_pattern(".git") or dirname]],
      },
    },
  },
}
