local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rubocop', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://github.com/rubocop/rubocop
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
