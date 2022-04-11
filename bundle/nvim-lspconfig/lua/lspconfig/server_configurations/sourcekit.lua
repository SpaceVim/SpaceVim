local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    root_dir = util.root_pattern('Package.swift', '.git'),
  },
  docs = {
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]],
    default_config = {
      root_dir = [[root_pattern("Package.swift", ".git")]],
    },
  },
}
