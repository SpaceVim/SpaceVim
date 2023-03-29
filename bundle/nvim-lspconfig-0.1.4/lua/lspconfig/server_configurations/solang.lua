local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'solang', '--language-server', '--target', 'ewasm' },
    filetypes = { 'solidity' },
    root_dir = util.find_git_ancestor,
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
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
