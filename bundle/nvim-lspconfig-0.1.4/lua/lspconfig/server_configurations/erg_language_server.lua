local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'els' },
    filetypes = { 'erg' },
    root_dir = function(fname)
      return util.root_pattern 'package.er'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/erg-lang/erg-language-server

ELS (erg-language-server) is a language server for the Erg programming language.

`els` can be installed via `cargo`:
 ```sh
 cargo install els
 ```
    ]],
    default_config = {
      root_dir = [[root_pattern("package.er") or find_git_ancestor]],
    },
  },
}
