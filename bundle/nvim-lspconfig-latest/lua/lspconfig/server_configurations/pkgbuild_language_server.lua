local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pkgbuild-language-server' },
    filetypes = { 'PKGBUILD' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/Freed-Wu/pkgbuild-language-server

Language server for ArchLinux/Windows Msys2's PKGBUILD.
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
