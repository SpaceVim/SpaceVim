local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nil' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = util.root_pattern('flake.nix', '.git'),
  },
  docs = {
    description = [[
https://github.com/oxalica/nil

A new language server for Nix Expression Language.

If you are using Nix with Flakes support, run `nix profile install github:oxalica/nil` to install.
Check the repository README for more information.
    ]],
    default_config = {
      root_dir = [[root_pattern("flake.nix", ".git")]],
    },
  },
}
