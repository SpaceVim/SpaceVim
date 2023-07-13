local util = require 'lspconfig.util'
return {
  default_config = {
    cmd = { 'uvls' },
    filetypes = { 'uvl' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://codeberg.org/caradhras/uvls
Language server for UVL, written using tree sitter and rust.
You can install the server easily using cargo:
```sh
git clone https://codeberg.org/caradhras/uvls
cd  uvls
cargo install --path .
```
Note: To activate properly nvim needs to know the uvl filetype.
You can add it via:
```lua
vim.cmd(\[\[au BufRead,BufNewFile *.uvl setfiletype uvl\]\])
```
]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
