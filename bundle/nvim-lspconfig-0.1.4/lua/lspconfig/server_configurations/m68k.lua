local util = require 'lspconfig.util'

local bin_name = 'm68k-lsp-server'
local cmd = { bin_name, '--stdio' }

if vim.fn.has 'win32' == 1 then
  cmd = { 'cmd.exe', '/C', bin_name, '--stdio' }
end

return {
  default_config = {
    cmd = cmd,
    filetypes = { 'asm68k' },
    root_dir = util.root_pattern('Makefile', '.git'),
    single_file_support = true,
  },
  docs = {
    description = [[
https://github.com/grahambates/m68k-lsp

Language server for Motorola 68000 family assembly

`m68k-lsp-server` can be installed via `npm`:

```sh
npm install -g m68k-lsp-server
```

Ensure you are using the 68k asm syntax variant in Neovim.

```lua
vim.g.asmsyntax = 'asm68k'
```
]],
  },
}
