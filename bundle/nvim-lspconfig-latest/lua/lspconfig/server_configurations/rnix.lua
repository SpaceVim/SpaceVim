local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rnix-lsp' },
    filetypes = { 'nix' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
    settings = {},
    init_options = {},
  },
  docs = {
    description = [[
https://github.com/nix-community/rnix-lsp

A language server for Nix providing basic completion and formatting via nixpkgs-fmt.

To install manually, run `cargo install rnix-lsp`. If you are using nix, rnix-lsp is in nixpkgs.

This server accepts configuration via the `settings` key.

    ]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
