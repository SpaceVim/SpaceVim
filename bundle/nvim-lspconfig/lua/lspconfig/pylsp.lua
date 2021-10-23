local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.pylsp = {
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
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/python-lsp/python-lsp-server

A Python 3.6+ implementation of the Language Server Protocol.

The language server can be installed via `pipx install 'python-lsp-server[all]'`.
Further instructions can be found in the [project's README](https://github.com/python-lsp/python-lsp-server).

Note: This is a community fork of `pyls`.
    ]],
  },
}
