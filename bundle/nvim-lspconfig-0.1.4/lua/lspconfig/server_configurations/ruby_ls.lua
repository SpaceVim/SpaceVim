local util = require 'lspconfig.util'

local bin_name = 'ruby-lsp'

-- defaults to stdio
local cmd = { bin_name }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'ruby' },
    root_dir = util.root_pattern('Gemfile', '.git'),
    init_options = {
      enabledFeatures = {
        'codeActions',
        'diagnostics',
        'documentHighlights',
        'documentSymbols',
        'formatting',
        'inlayHint',
      },
    },
  },
  docs = {
    description = [[
https://shopify.github.io/ruby-lsp/

This gem is an implementation of the language server protocol specification for
Ruby, used to improve editor features.

Install the gem. There's no need to require it, since the server is used as a
standalone executable.

```sh
group :development do
  gem "ruby-lsp", require: false
end
```
    ]],
    default_config = {
      root_dir = [[root_pattern("Gemfile", ".git")]],
    },
  },
}
