local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = {},
    filetypes = { 'rescript' },
    root_dir = util.root_pattern('bsconfig.json', '.git'),
    settings = {},
  },
  docs = {
    description = [[
https://github.com/rescript-lang/rescript-vscode

ReScript language server

**By default, rescriptls doesn't have a `cmd` set.** This is because nvim-lspconfig does not make assumptions about your path.
You have to install the language server manually.

You can use the bundled language server inside the [vim-rescript](https://github.com/rescript-lang/vim-rescript) repo.

Clone the vim-rescript repo and point `cmd` to `server.js` inside `server/out` directory:

```lua
cmd = {'node', '<path_to_repo>/server/out/server.js', '--stdio'}

```

If you have vim-rescript installed you can also use that installation. for example if you're using packer.nvim you can set cmd to something like this:

```lua
cmd = {
  'node',
  '/home/username/.local/share/nvim/site/pack/packer/start/vim-rescript/server/out/server.js',
  '--stdio'
}
```

Another option is to use vscode extension [release](https://github.com/rescript-lang/rescript-vscode/releases).
Take a look at [here](https://github.com/rescript-lang/rescript-vscode#use-with-other-editors) for instructions.
]],
  },
}
