local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'nc', 'localhost', os.getenv 'UNISON_LSP_PORT' or '5757' },
    filetypes = { 'unison' },
    root_dir = util.root_pattern '*.u',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/unisonweb/unison/blob/trunk/docs/language-server.markdown


    ]],
  },
}
