local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'sqls' },
    filetypes = { 'sql', 'mysql' },
    root_dir = util.root_pattern 'config.yml',
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/lighttiger2505/sqls

```lua
require'lspconfig'.sqls.setup{
  cmd = {"path/to/command", "-config", "path/to/config.yml"};
  ...
}
```
Sqls can be installed via `go get github.com/lighttiger2505/sqls`. Instructions for compiling Sqls from the source can be found at [lighttiger2505/sqls](https://github.com/lighttiger2505/sqls).

    ]],
  },
}
