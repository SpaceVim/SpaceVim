local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'purescript-language-server', '--stdio' },
    filetypes = { 'purescript' },
    root_dir = util.root_pattern('bower.json', 'psc-package.json', 'spago.dhall', 'flake.nix', 'shell.nix'),
  },
  docs = {
    description = [[
https://github.com/nwolverson/purescript-language-server

The `purescript-language-server` can be added to your project and `$PATH` via

* JavaScript package manager such as npm, pnpm, Yarn, et al.
* Nix under the `nodePackages` and `nodePackages_latest` package sets
]],
    default_config = {
      root_dir = [[root_pattern('spago.dhall', 'psc-package.json', 'bower.json', 'flake.nix', 'shell.nix'),]],
    },
  },
}
