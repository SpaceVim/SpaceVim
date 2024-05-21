local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'uiua', 'lsp' },
    filetypes = { 'uiua' },
    root_dir = function(fname)
      return util.root_pattern('main.ua', '.fmt.ua')(fname) or util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/uiua-lang/uiua/

The builtin language server of the Uiua interpreter.

The Uiua interpreter can be installed with `cargo install uiua`
]],
    default_config = {
      cmd = { 'uiua', 'lsp' },
      filetypes = { 'uiua' },
      root_dir = [[
        root_pattern(
          'main.ua',
          'fmt.ua',
          '.git'
        )
      ]],
    },
  },
}
