local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ols' },
    filetypes = { 'odin' },
    root_dir = util.root_pattern('ols.json', '.git', '*.odin'),
  },
  docs = {
    description = [[
           https://github.com/DanielGavin/ols

           `Odin Language Server`.
        ]],
    default_config = {
      root_dir = [[util.root_pattern("ols.json", ".git", "*.odin")]],
    },
  },
}
