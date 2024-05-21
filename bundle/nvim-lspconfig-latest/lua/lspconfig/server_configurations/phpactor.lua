local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'phpactor', 'language-server' },
    filetypes = { 'php' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git', '.phpactor.json', '.phpactor.yml')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://github.com/phpactor/phpactor

Installation: https://phpactor.readthedocs.io/en/master/usage/standalone.html#global-installation
]],
    default_config = {
      cmd = { 'phpactor', 'language-server' },
      root_dir = [[root_pattern("composer.json", ".git")]],
    },
  },
}
