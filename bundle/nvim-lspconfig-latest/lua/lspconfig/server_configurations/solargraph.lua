local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'solargraph', 'stdio' },
    settings = {
      solargraph = {
        diagnostics = true,
      },
    },
    init_options = { formatting = true },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://solargraph.org/

solargraph, a language server for Ruby

You can install solargraph via gem install.

```sh
gem install --user-install solargraph
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
