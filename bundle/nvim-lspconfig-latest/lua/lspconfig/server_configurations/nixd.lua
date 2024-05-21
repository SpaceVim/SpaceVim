local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = function(fname)
      return util.root_pattern 'flake.nix'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/nix-community/nixd

Nix language server, based on nix libraries.

If you are using Nix with Flakes support, run `nix profile install github:nix-community/nixd` to install.
Check the repository README for more information.
    ]],
    default_config = {
      root_dir = [[root_pattern("flake.nix",".git")]],
    },
  },
}
