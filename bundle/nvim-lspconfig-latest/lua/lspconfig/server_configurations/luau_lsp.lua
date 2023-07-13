local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'luau-lsp', 'lsp' },
    filetypes = { 'luau' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    [[
https://github.com/JohnnyMorganz/luau-lsp

Language server for the [Luau](https://luau-lang.org/) language.

`luau-lsp` can be installed by downloading one of the release assets available at https://github.com/JohnnyMorganz/luau-lsp.

You might also have to set up automatic filetype detection for Luau files, for example like so:

```vim
autocmd BufRead,BufNewFile *.luau setf luau
```
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
