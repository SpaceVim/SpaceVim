local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'bzl' },
    root_dir = util.root_pattern '.plzconfig',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/thought-machine/please

High-performance extensible build system for reproducible multi-language builds.

The `plz` binary will automatically install the LSP for you on first run
]],
  },
}
