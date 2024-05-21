local util = require 'lspconfig.util'

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities.offsetEncoding = { 'utf-8', 'utf-16' }

return {
  default_config = {
    cmd = { 'fennel-ls' },
    filetypes = { 'fennel' },
    root_dir = function(dir)
      return util.find_git_ancestor(dir)
    end,
    settings = {},
    capabilities = default_capabilities,
  },
  docs = {
    description = [[
https://sr.ht/~xerool/fennel-ls/

A language server for fennel.
]],
  },
}
