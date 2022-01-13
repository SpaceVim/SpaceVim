local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.mint = {
  default_config = {
    cmd = { 'mint', 'ls' },
    filetypes = { 'mint' },
    root_dir = function(fname)
      return util.root_pattern 'mint.json'(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://www.mint-lang.com

Install Mint using the [instructions](https://www.mint-lang.com/install).
The language server is included since version 0.12.0.
]],
  },
}
