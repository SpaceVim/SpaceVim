local util = require 'lspconfig.util'

return {
  default_config = {
    cmd = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = util.root_pattern('hie.yaml', 'stack.yaml', 'cabal.project', '*.cabal', 'package.yaml'),
    single_file_support = true,
    settings = {
      haskell = {
        formattingProvider = 'ormolu',
        cabalFormattingProvider = 'cabalfmt',
      },
    },
    lspinfo = function(cfg)
      local extra = {}
      local function on_stdout(_, data, _)
        local version = data[1]
        table.insert(extra, 'version:   ' .. version)
      end

      local opts = {
        cwd = cfg.cwd,
        stdout_buffered = true,
        on_stdout = on_stdout,
      }
      local chanid = vim.fn.jobstart({ cfg.cmd[1], '--version' }, opts)
      vim.fn.jobwait { chanid }
      return extra
    end,
  },

  docs = {
    description = [[
https://github.com/haskell/haskell-language-server

Haskell Language Server

If you are using HLS 1.9.0.0, enable the language server to launch on Cabal files as well:

```lua
require('lspconfig')['hls'].setup{
  filetypes = { 'haskell', 'lhaskell', 'cabal' },
}
```
    ]],

    default_config = {
      root_dir = [[root_pattern("hie.yaml", "stack.yaml", "cabal.project", "*.cabal", "package.yaml")]],
    },
  },
}
