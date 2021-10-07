local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

local server_name = 'sorbet'
local bin_name = 'srb'

configs[server_name] = {
  default_config = {
    cmd = { bin_name, 'tc', '--lsp' },
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
  },
  docs = {
    description = [[
https://sorbet.org

Sorbet is a fast, powerful type checker designed for Ruby.

You can install Sorbet via gem install. You might also be interested in how to set
Sorbet up for new projects: https://sorbet.org/docs/adopting.

```sh
gem install sorbet
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
