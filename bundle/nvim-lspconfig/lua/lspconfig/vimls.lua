local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'vimls'
local bin_name = 'vim-language-server'
if vim.fn.has 'win32' == 1 then
  bin_name = bin_name .. '.cmd'
end

configs[server_name] = {
  default_config = {
    cmd = { bin_name, '--stdio' },
    filetypes = { 'vim' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or vim.fn.getcwd()
    end,
    init_options = {
      iskeyword = '@,48-57,_,192-255,-#',
      vimruntime = '',
      runtimepath = '',
      diagnostic = { enable = true },
      indexes = {
        runtimepath = true,
        gap = 100,
        count = 3,
        projectRootPatterns = { 'runtime', 'nvim', '.git', 'autoload', 'plugin' },
      },
      suggest = { fromVimruntime = true, fromRuntimepath = true },
    },
  },
  docs = {
    description = [[
https://github.com/iamcco/vim-language-server

You can install vim-language-server via npm:
```sh
npm install -g vim-language-server
```
]],
  },
}
