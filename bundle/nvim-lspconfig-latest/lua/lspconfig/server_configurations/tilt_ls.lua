local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'tilt', 'lsp', 'start' },
    filetypes = { 'tiltfile' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/tilt-dev/tilt

Tilt language server.

You might need to add filetype detection manually:

```vim
autocmd BufRead Tiltfile setf=tiltfile
```
]],
    default_config = {
      root_dir = [[root_pattern(".git")]],
    },
  },
}
