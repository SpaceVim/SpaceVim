local util = require 'lspconfig.util'

local cmd = {
  'phan',
  '-m',
  'json',
  '--no-color',
  '--no-progress-bar',
  '-x',
  '-u',
  '-S',
  '--language-server-on-stdin',
  '--allow-polyfill-parser',
}

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'php' },
    single_file_support = true,
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
  },
  docs = {
    description = [[
https://github.com/phan/phan

Installation: https://github.com/phan/phan#getting-started
]],
    default_config = {
      cmd = cmd,
      root_dir = [[root_pattern("composer.json", ".git")]],
    },
  },
}
