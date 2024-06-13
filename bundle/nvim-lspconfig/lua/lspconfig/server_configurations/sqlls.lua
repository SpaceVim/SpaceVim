local util = require 'lspconfig.util'

return {
  default_config = {
    filetypes = { 'sql', 'mysql' },
    root_dir = util.root_pattern '.sqllsrc.json',
    settings = {},
  },
  docs = {
    description = [[
https://github.com/joe-re/sql-language-server

`cmd` value is **not set** by default. The `cmd` value can be overridden in the `setup` table;

```lua
require'lspconfig'.sqlls.setup{
  cmd = {"path/to/command", "up", "--method", "stdio"};
  ...
}
```

This LSP can be installed via  `npm`. Find further instructions on manual installation of the sql-language-server at [joe-re/sql-language-server](https://github.com/joe-re/sql-language-server).
<br>
    ]],
  },
}
