local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'dot-language-server', '--stdio' },
    filetypes = { 'dot' },
    root_dir = util.find_git_ancestor,
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/nikeee/dot-language-server

`dot-language-server` can be installed via `npm`:
```sh
npm install -g dot-language-server
```
    ]],
  },
}
