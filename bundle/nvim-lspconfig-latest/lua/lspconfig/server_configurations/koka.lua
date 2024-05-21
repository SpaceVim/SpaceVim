local util = require 'lspconfig.util'

local root_files = {}

local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-8' },
}

return {
  default_config = {
    cmd = { 'koka', '--language-server' },
    filetypes = { 'kk' },
    root_dir = function(fname)
      return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
    end,
    single_file_support = true,
    capabilities = default_capabilities,
  },
  commands = {},
  docs = {
    description = [[
    https://koka-lang.github.io/koka/doc/index.html
Koka is a functional programming language with effect types and handlers.
    ]],
    default_config = {
      root_dir = [[
      ]],
      capabilities = [[default capabilities, with offsetEncoding utf-8]],
    },
  },
}
