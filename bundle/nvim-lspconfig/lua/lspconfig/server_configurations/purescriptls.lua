local util = require 'lspconfig.util'

local bin_name = 'purescript-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
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
