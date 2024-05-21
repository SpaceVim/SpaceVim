local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'rescript-language-server', '--stdio' },
    filetypes = { 'rescript' },
    root_dir = util.root_pattern('bsconfig.json', 'rescript.json', '.git'),
    settings = {},
    init_options = {
      extensionConfiguration = {
        askToStartBuild = false,
      },
    },
  },
  docs = {
    description = [[
https://github.com/rescript-lang/rescript-vscode/tree/master/server

ReScript Language Server can be installed via npm:
```sh
npm install -g @rescript/language-server
```

See the init_options supported (see https://github.com/rescript-lang/rescript-vscode/tree/master/server/config.md):
]],
    root_dir = [[root_pattern('bsconfig.json', 'rescript.json', '.git')]],
  },
}
