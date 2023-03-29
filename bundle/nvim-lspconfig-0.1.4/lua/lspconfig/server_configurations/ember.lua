local util = require 'lspconfig.util'

local bin_name = 'ember-language-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'handlebars', 'typescript', 'javascript' },
    root_dir = util.root_pattern('ember-cli-build.js', '.git'),
  },
  docs = {
    description = [[
https://github.com/lifeart/ember-language-server

`ember-language-server` can be installed via `npm`:

```sh
npm install -g @lifeart/ember-language-server
```
]],
    default_config = {
      root_dir = [[root_pattern("ember-cli-build.js", ".git")]],
    },
  },
}
