local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dprint', 'lsp' },
    filetypes = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'json',
      'jsonc',
      'markdown',
      'python',
      'toml',
      'rust',
      'roslyn',
    },
    root_dir = util.root_pattern('dprint.json', '.dprint.json', 'dprint.jsonc', '.dprint.jsonc'),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/dprint/dprint

Pluggable and configurable code formatting platform written in Rust.
  ]],
    default_config = {
      root_dir = util.root_pattern('dprint.json', '.dprint.json', 'dprint.jsonc', '.dprint.jsonc'),
    },
  },
}
