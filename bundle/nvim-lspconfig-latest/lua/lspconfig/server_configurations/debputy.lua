local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'debputy', 'lsp', 'server' },
    filetypes = { 'debcontrol', 'debcopyright', 'debchangelog', 'make', 'yaml' },
    root_dir = util.root_pattern 'debian',
  },
  docs = {
    description = [[
https://salsa.debian.org/debian/debputy

Language Server for Debian packages.
]],
  },
}
