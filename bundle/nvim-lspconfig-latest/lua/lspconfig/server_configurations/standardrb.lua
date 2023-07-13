local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'standardrb', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://github.com/testdouble/standard

Ruby Style Guide, with linter & automatic code fixer.
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
