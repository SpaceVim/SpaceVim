local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'motoko-lsp', '--stdio' },
    filetypes = { 'motoko' },
    root_dir = util.root_pattern('dfx.json', '.git'),
    init_options = {
      formatter = 'auto',
    },
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/dfinity/vscode-motoko

Language server for the Motoko programming language.
    ]],
    default_config = {
      root_dir = [[root_pattern("dfx.json", ".git")]],
    },
  },
}
