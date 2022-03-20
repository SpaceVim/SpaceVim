local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'openscad-language-server' },
    filetypes = { 'openscad' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [=[
https://github.com/dzhu/openscad-language-server

A Language Server Protocol server for OpenSCAD

You can build and install `openscad-language-server` binary with `cargo`:
```sh
cargo install openscad-language-server
```

Vim does not have built-in syntax for the `openscad` filetype currently.

This can be added via an autocmd:

```lua
vim.cmd [[ autocmd BufRead,BufNewFile *.scad set filetype=openscad ]]
```

or by installing a filetype plugin such as https://github.com/sirtaj/vim-openscad
]=],
  },
}
