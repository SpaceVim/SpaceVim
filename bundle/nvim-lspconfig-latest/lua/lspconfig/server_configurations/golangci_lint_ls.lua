local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'golangci-lint-langserver' },
    filetypes = { 'go', 'gomod' },
    init_options = {
      command = { 'golangci-lint', 'run', '--out-format', 'json' },
    },
    root_dir = function(fname)
      return util.root_pattern(
        '.golangci.yml',
        '.golangci.yaml',
        '.golangci.toml',
        '.golangci.json',
        'go.work',
        'go.mod',
        '.git'
      )(fname)
    end,
  },
  docs = {
    description = [[
Combination of both lint server and client

https://github.com/nametake/golangci-lint-langserver
https://github.com/golangci/golangci-lint


Installation of binaries needed is done via

```
go install github.com/nametake/golangci-lint-langserver@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

]],
    default_config = {
      root_dir = [[root_pattern('.golangci.yml', '.golangci.yaml', '.golangci.toml', '.golangci.json', 'go.work', 'go.mod', '.git')]],
    },
  },
}
