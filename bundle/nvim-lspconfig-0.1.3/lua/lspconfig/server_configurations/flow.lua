local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'npx', '--no-install', 'flow', 'lsp' },
    filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx' },
    root_dir = util.root_pattern '.flowconfig',
  },
  docs = {
    description = [[
https://flow.org/
https://github.com/facebook/flow

See below for how to setup Flow itself.
https://flow.org/en/docs/install/

See below for lsp command options.

```sh
npx flow lsp --help
```
    ]],
    default_config = {
      root_dir = [[root_pattern(".flowconfig")]],
    },
  },
}
