local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'emmet-ls', '--stdio' },
    filetypes = { 'html', 'css' },
    root_dir = util.find_git_ancestor,
  },
  docs = {
    description = [[
https://github.com/aca/emmet-ls

Package can be installed via `npm`:
```sh
npm install -g emmet-ls
```
]],
    default_config = {
      root_dir = 'git root',
    },
  },
}
