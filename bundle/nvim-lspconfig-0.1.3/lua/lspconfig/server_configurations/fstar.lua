local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'fstar.exe', '--lsp' },
    filetypes = { 'fstar' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/FStarLang/FStar

LSP support is included in FStar. Make sure `fstar.exe` is in your PATH.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
