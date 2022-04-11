local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ghcide', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = util.root_pattern('stack.yaml', 'hie-bios', 'BUILD.bazel', 'cabal.config', 'package.yaml'),
  },

  docs = {
    description = [[
https://github.com/digital-asset/ghcide

A library for building Haskell IDE tooling.
"ghcide" isn't for end users now. Use "haskell-language-server" instead of "ghcide".
]],
    default_config = {
      root_dir = [[root_pattern("stack.yaml", "hie-bios", "BUILD.bazel", "cabal.config", "package.yaml")]],
    },
  },
}
