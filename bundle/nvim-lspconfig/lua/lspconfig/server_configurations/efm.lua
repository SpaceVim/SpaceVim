local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'efm-langserver' },
    root_dir = util.find_git_ancestor,
    -- EFM does not support NULL root directories
    -- https://github.com/neovim/nvim-lspconfig/issues/1412
    single_file_support = false,
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
      root_dir = [[util.root_pattern(".git")]],
    },
  },
}
