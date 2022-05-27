local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'reason-language-server' },
    filetypes = { 'reason' },
    root_dir = util.root_pattern('bsconfig.json', '.git'),
  },
  docs = {
    description = [[
Reason language server

**By default, reason_ls doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.

You can install reason language server from [reason-language-server](https://github.com/jaredly/reason-language-server) repository.

```lua
cmd = {'<path_to_reason_language_server>'}
```
]],
  },
}
