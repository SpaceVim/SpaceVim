local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'lwc-language-server', '--stdio' },
    filetypes = { 'javascript', 'html' },
    root_dir = util.root_pattern 'sfdx-project.json',
    init_options = {
      embeddedLanguages = {
        javascript = true,
      },
    },
  },
  docs = {
    description = [[
https://github.com/forcedotcom/lightning-language-server/

Language server for Lightning Web Components.

For manual installation, utilize the official [NPM package](https://www.npmjs.com/package/@salesforce/lwc-language-server).
Then, configure `cmd` to run the Node script at the unpacked location:

```lua
require'lspconfig'.lwc_ls.setup {
  cmd = {
    'node',
    '/path/to/node_modules/@salesforce/lwc-language-server/bin/lwc-language-server.js',
    '--stdio'
  }
}
```
]],
    default_config = {
      root_dir = [[root_pattern('sfdx-project.json')]],
    },
  },
}
