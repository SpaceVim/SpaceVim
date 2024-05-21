local util = require('lspconfig').util

return {
  default_config = {
    cmd = { 'pylyzer', '--server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      local root_files = {
        'setup.py',
        'tox.ini',
        'requirements.txt',
        'Pipfile',
        'pyproject.toml',
      }
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    settings = {
      python = {
        diagnostics = true,
        inlayHints = true,
        smartCompletion = true,
        checkOnType = false,
      },
    },
  },
  docs = {
    description = [[
  https://github.com/mtshiba/pylyzer

  `pylyzer`, a fast static code analyzer & language server for Python.
    ]],
  },
}
