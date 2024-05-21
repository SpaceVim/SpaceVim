local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'vacuum', 'language-server' },
    filetypes = { 'yaml.openapi', 'json.openapi' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
Vacuum is the worlds fastest OpenAPI 3, OpenAPI 2 / Swagger linter and quality analysis tool.

You can install vacuum using mason or follow the instructions here: https://github.com/daveshanley/vacuum

The file types are not detected automatically, you can register them manually (see below) or override the filetypes:

```lua
vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
  },
}
```
]],
  },
}
