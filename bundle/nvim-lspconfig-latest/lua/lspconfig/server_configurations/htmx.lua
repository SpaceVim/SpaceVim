local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'htmx-lsp' },
    filetypes = { 'html', 'templ' },
    single_file_support = true,
    root_dir = function(fname)
      return util.find_git_ancestor(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/ThePrimeagen/htmx-lsp

`htmx-lsp` can be installed via `cargo`:
```sh
cargo install htmx-lsp
```

Lsp is still very much work in progress and experimental. Use at your own risk.
]],
  },
}
