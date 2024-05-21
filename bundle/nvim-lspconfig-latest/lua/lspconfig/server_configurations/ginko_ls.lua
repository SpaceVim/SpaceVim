local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ginko_ls' },
    filetypes = { 'dts' },
    root_dir = util.find_git_ancestor,
    settings = {},
  },
  docs = {
    description = [[
`ginko_ls` is meant to be a feature-complete language server for device-trees.
Language servers can be used in many editors, such as Visual Studio Code, Emacs
or Vim

Install `ginko_ls` from https://github.com/Schottkyc137/ginko and add it to path

`ginko_ls` doesn't require any configuration.
]],
  },
}
