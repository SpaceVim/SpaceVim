local util = require 'lspconfig.util'

local root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  '.git',
}

return {
  default_config = {
    cmd = { 'jedi-language-server' },
    filetypes = { 'python' },
    root_dir = util.root_pattern(unpack(root_files)),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/pappasam/jedi-language-server

`jedi-language-server`, a language server for Python, built on top of jedi
    ]],
    default_config = {
      root_dir = "vim's starting directory",
    },
  },
}
