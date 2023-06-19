local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'efm-langserver' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },

  docs = {
    description = [[
https://github.com/mattn/efm-langserver

General purpose Language Server that can use specified error message format generated from specified command.

Requires at minimum EFM version [v0.0.38](https://github.com/mattn/efm-langserver/releases/tag/v0.0.38) to support
launching the language server on single files. If on an older version of EFM, disable single file support:

```lua
require('lspconfig')['efm'].setup{
  settings = ..., -- You must populate this according to the EFM readme
  filetypes = ..., -- Populate this according to the note below
  single_file_support = false, -- This is the important line for supporting older version of EFM
}
```

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
