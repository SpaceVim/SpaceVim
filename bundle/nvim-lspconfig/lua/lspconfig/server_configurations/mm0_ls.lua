local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mm0-rs', 'server' },
    root_dir = util.find_git_ancestor,
    filetypes = { 'metamath-zero' },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/digama0/mm0

Language Server for the metamath-zero theorem prover.

Requires [mm0-rs](https://github.com/digama0/mm0/tree/master/mm0-rs) to be installed
and available on the `PATH`.
    ]],
  },
}
