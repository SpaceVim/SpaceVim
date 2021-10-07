local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'beancount'
local bin_name = 'beancount-langserver'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    filetypes = { 'beancount' },
    root_dir = function(fname)
      return util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
    init_options = {
      -- this is the path to the beancout journal file
      journalFile = '',
      -- this is the path to the python binary with beancount installed
      pythonPath = 'python3',
    },
  },
  docs = {
    description = [[
https://github.com/polarmutex/beancount-language-server#installation

See https://github.com/polarmutex/beancount-language-server#configuration for configuration options
]],
    default_config = {
      root_dir = [[root_pattern("elm.json")]],
    },
  },
}
