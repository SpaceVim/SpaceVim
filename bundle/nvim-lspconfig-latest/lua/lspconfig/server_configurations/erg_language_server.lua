local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'erg', '--language-server' },
    filetypes = { 'erg' },
    root_dir = function(fname)
      return util.root_pattern 'package.er'(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/erg-lang/erg#flags ELS

ELS (erg-language-server) is a language server for the Erg programming language.

erg-language-server can be installed via `cargo` and used as follows:
 ```sh
 cargo install erg --features els
 erg --language-server
 ```
    ]],
    default_config = {
      root_dir = [[root_pattern("package.er") or find_git_ancestor]],
    },
  },
}
