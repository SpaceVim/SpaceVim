local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'serve-d' },
    filetypes = { 'd' },
    root_dir = util.root_pattern('dub.json', 'dub.sdl', '.git'),
  },
  docs = {
    description = [[
           https://github.com/Pure-D/serve-d

           `Microsoft language server protocol implementation for D using workspace-d.`
           Download a binary from https://github.com/Pure-D/serve-d/releases and put it in your $PATH.
        ]],
    default_config = {
      root_dir = [[util.root_pattern("dub.json", "dub.sdl", ".git")]],
    },
  },
}
