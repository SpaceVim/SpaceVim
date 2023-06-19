local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/python-lsp/python-lsp-server

A Python 3.6+ implementation of the Language Server Protocol.

See the [project's README](https://github.com/python-lsp/python-lsp-server) for installation instructions.

Configuration options are documented [here](https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md).
In order to configure an option, it must be translated to a nested Lua table and included in the `settings` argument to the `setup{}` function.
For example, in order to set the `pylsp.plugins.pycodestyle.ignore` option:
```lua
require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}
```

Note: This is a community fork of `pyls`.
    ]],
  },
}
