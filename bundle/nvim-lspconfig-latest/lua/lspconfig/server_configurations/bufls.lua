local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'bufls', 'serve' },
    filetypes = { 'proto' },
    root_dir = function(fname)
      return util.root_pattern('buf.work.yaml', '.git')(fname)
    end,
  },
  docs = {
    description = [[
https://github.com/bufbuild/buf-language-server

`buf-language-server` can be installed via `go install`:
```sh
go install github.com/bufbuild/buf-language-server/cmd/bufls@latest
```

bufls is a Protobuf language server compatible with Buf modules and workspaces
]],
    default_config = {
      root_dir = [[root_pattern("buf.work.yaml", ".git")]],
    },
  },
}
