local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift', 'c', 'cpp', 'objective-c', 'objective-cpp' },
    root_dir = function(filename, _)
      return util.root_pattern 'buildServer.json'(filename)
        or util.root_pattern('*.xcodeproj', '*.xcworkspace')(filename)
        or util.find_git_ancestor(filename)
        -- better to keep it at the end, because some modularized apps contain multiple Package.swift files
        or util.root_pattern('compile_commands.json', 'Package.swift')(filename)
    end,
  },
  docs = {
    description = [[
https://github.com/apple/sourcekit-lsp

Language server for Swift and C/C++/Objective-C.
    ]],
    default_config = {
      root_dir = [[root_pattern("buildServer.json", "*.xcodeproj", "*.xcworkspace", ".git", "compile_commands.json", "Package.swift")]],
    },
  },
}
