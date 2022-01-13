local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'efm'
local bin_name = 'efm-langserver'

configs[server_name] = {
  default_config = {
    cmd = { bin_name },
    root_dir = function(fname)
      return util.root_pattern '.git'(fname) or util.path.dirname(fname)
    end,
  },

  docs = {
    description = [[
https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.

Note: In order for neovim's built-in language server client to send the appropriate `languageId` to EFM, **you must
specify `filetypes` in your call to `setup{}`**. Otherwise `lspconfig` will launch EFM on the `BufEnter` instead
of the `FileType` autocommand, and the `filetype` variable used to populate the `languageId` will not yet be set.

```lua
require('lspconfig')['efm'].setup{
  settings = ..., -- You must populate this according to the EFM readme
  filetypes = { 'python','cpp','lua' }
}
```

]],
    default_config = {
      root_dir = [[util.root_pattern(".git")(fname) or util.path.dirname(fname)]],
    },
  },
}
-- vim:et ts=2 sw=2
