local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'cobol-language-support' },
    filetypes = { 'cobol' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
Cobol language support
    ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
