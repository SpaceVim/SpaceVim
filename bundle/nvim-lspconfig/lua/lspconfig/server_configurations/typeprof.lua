local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'typeprof', '--lsp', '--stdio' },
    filetypes = { 'ruby', 'eruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://github.com/ruby/typeprof

`typeprof` is the built-in analysis and LSP tool for Ruby 3.1+.
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
