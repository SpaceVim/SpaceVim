local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'smarty-language-server', '--stdio' },
    filetypes = { 'smarty' },
    root_dir = function(pattern)
      local cwd = vim.loop.cwd()
      local root = util.root_pattern('composer.json', '.git')(pattern)

      -- prefer cwd if root is a descendant
      return util.path.is_descendant(cwd, root) and cwd or root
    end,
    settings = {
      smarty = {
        pluginDirs = {},
      },
      css = {
        validate = true,
      },
    },
    init_options = {
      storageDir = nil,
    },
  },
  docs = {
    description = [[
https://github.com/landeaux/vscode-smarty-langserver-extracted

Language server for Smarty.

`smarty-language-server` can be installed via `npm`:

```sh
npm i -g vscode-smarty-langserver-extracted
```
]],
  },
}
