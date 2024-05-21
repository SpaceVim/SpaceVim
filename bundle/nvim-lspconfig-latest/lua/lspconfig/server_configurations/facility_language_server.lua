local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'facility-language-server' },
    filetypes = { 'fsd' },
    single_file_support = true,
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/FacilityApi/FacilityLanguageServer

Facility language server protocol (LSP) support.
]],
  },
}
