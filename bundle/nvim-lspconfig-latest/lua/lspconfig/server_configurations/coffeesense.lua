local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'coffeesense-language-server', '--stdio' },
    filetypes = { 'coffee' },
    root_dir = util.root_pattern 'package.json',
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/phil294/coffeesense

CoffeeSense Language Server
`coffeesense-language-server` can be installed via `npm`:
```sh
npm install -g coffeesense-language-server
```
]],
  },
}
