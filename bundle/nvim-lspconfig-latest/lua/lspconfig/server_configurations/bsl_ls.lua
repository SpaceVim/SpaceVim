local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'bsl', 'os' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
    https://github.com/1c-syntax/bsl-language-server

    Language Server Protocol implementation for 1C (BSL) - 1C:Enterprise 8 and OneScript languages.

    ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
