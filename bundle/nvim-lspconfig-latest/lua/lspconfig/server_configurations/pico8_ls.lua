local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'pico8-ls', '--stdio' },
    filetypes = { 'p8' },
    root_dir = util.root_pattern '*.p8',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/japhib/pico8-ls

Full language support for the PICO-8 dialect of Lua.
]],
  },
}
