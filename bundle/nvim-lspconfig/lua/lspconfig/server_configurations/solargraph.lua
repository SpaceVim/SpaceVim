local util = require 'lspconfig.util'

local bin_name = 'solargraph'
local cmd = { bin_name, 'stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, 'stdio' }
end

return {
  default_config = {
    cmd = cmd,
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
