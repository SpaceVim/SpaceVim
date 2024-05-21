local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bitbake-language-server' },
    filetypes = { 'bitbake' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
🛠️ bitbake language server
]],
  },
}
