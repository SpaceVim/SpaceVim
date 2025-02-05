--=============================================================================
-- init.lua
-- Copyright 2025 Eric Wong
-- Author: Eric Wong < wsdjeg@outlook.com >
-- License: GPLv3
--=============================================================================

vim.opt.runtimepath:append('.')
vim.opt.runtimepath:append('~/.SpaceVim')

require('plug').setup({

  bundle_dir = 'D:/bundle_dir',
})

require('plug').add({
  {
    'wsdjeg/scrollbar.vim',
    events = { 'VimEnter' },
    config = function() end,
  },
  {
    'wsdjeg/flygrep.nvim',
    cmds = { 'FlyGrep' },
    config = function()
      require('flygrep').setup()
    end,
  },
  {
    'rhysd/clever-f.vim',
    on_map = { '<Plug>(clever-f' },
  },
})
vim.cmd('nmap f <Plug>(clever-f-f)')
