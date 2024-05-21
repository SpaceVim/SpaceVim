local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    root_dir = function(fname)
      return util.root_pattern 'mix.exs'(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/elixir-tools/next-ls

**By default, next-ls does not set its `cmd`. Please see the following [detailed instructions](https://www.elixir-tools.dev/docs/next-ls/installation/) for possible installation methods.**
]],
  },
}
