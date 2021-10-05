local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'

configs.hls = {
  default_config = {
    cmd = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_dir = util.root_pattern('*.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml'),
    settings = {
      haskell = {
        formattingProvider = 'ormolu',
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
        ]],

    default_config = {
      root_dir = [[root_pattern("*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml")]],
    },
  },
}
