local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'steep', 'langserver' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = util.root_pattern('Steepfile', '.git'),
  },
  docs = {
    description = [[
https://github.com/soutaro/steep

`steep` is a static type checker for Ruby.

You need `Steepfile` to make it work. Generate it with `steep init`.
]],
    default_config = {
      root_dir = [[root_pattern("Steepfile", ".git")]],
    },
  },
}
