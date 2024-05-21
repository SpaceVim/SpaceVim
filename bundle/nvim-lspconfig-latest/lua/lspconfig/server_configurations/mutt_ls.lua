local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'mutt-language-server' },
    filetypes = { 'muttrc', 'neomuttrc' },
    root_dir = util.find_git_ancestor(),
    single_file_support = true,
    settings = {},
  },
  docs = {
    description = [[
https://github.com/neomutt/mutt-language-server

A language server for (neo)mutt's muttrc. It can be installed via pip.

```sh
pip install mutt-language-server
```
  ]],
    default_config = {
      root_dir = [[util.find_git_ancestor]],
    },
  },
}
