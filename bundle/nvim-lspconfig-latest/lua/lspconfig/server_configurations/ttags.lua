local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'ttags', 'lsp' },
    filetypes = { 'ruby', 'rust', 'javascript', 'haskell' },
    root_dir = util.root_pattern '.git',
  },
  docs = {
    description = [[
https://github.com/npezza93/ttags
    ]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
