local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {
      'swipl',
      '-g',
      'use_module(library(lsp_server)).',
      '-g',
      'lsp_server:main',
      '-t',
      'halt',
      '--',
      'stdio',
    },
    filetypes = { 'prolog' },
    root_dir = util.root_pattern 'pack.pl',
    single_file_support = true,
  },
  docs = {
    description = [[
  https://github.com/jamesnvc/lsp_server

  Language Server Protocol server for SWI-Prolog
  ]],
  },
}
