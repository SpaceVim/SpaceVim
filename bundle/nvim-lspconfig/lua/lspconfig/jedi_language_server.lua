local configs = require 'lspconfig/configs'

configs.jedi_language_server = {
  default_config = {
    cmd = { 'jedi-language-server' },
    filetypes = { 'python' },
    root_dir = function(fname)
      return vim.fn.getcwd()
    end,
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
