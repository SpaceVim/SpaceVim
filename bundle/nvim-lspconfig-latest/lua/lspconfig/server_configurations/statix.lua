local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'statix' },
    filetypes = { 'nix' },
    single_file_support = true,
    root_dir = util.root_pattern('flake.nix', '.git'),
  },
  docs = {
    description = [[
https://github.com/nerdypepper/statix

lints and suggestions for the nix programming language
    ]],
    default_config = {
      root_dir = [[root_pattern("flake.nix", ".git")]],
    },
  },
}
