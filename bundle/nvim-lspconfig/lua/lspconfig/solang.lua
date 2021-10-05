local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.solang = {
  default_config = {
    cmd = { 'solang', '--language-server' },
    filetypes = { 'solidity' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
A language server for Solidity

See the [documentation](https://solang.readthedocs.io/en/latest/installing.html) for installation instructions.

The language server only provides the following capabilities:
* Syntax highlighting
* Diagnostics
* Hover

There is currently no support for completion, goto definition, references, or other functionality.

]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
