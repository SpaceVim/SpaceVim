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
    https://github.com/lexical-lsp/lexical

    Lexical is a next-generation language server for the Elixir programming language.

    Follow the [Detailed Installation Instructions](https://github.com/lexical-lsp/lexical/blob/main/pages/installation.md)

    **By default, `lexical` doesn't have a `cmd` set.**
    This is because nvim-lspconfig does not make assumptions about your path.
    ]],
  },
}
