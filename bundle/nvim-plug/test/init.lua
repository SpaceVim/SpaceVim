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
  raw_plugin_dir = 'D:/bundle_dir/raw_plugin',
  ui = 'default',
  http_proxy = 'http://127.0.0.1:7890',
  https_proxy = 'http://127.0.0.1:7890',
  enable_priority = true,
  max_processes = 16,
})

require('plug').add({
  {
    'wsdjeg/SourceCounter.vim',
    cmds = { 'SourceCounter' },
  },
  {
    type = 'raw',
    url = 'https://gist.githubusercontent.com/wsdjeg/4ac99019c5ca156d35704550648ba321/raw/4e8c202c74e98b5d56616c784bfbf9b873dc8868/markdown.vim',
    script_type = 'after/syntax',
  },
  {
    type = 'raw',
    url = 'https://raw.githubusercontent.com/EmmanuelOga/easing/refs/heads/master/lib/easing.lua',
    script_type = 'lua',
  },
  {
    'wsdjeg/git.vim',
    cmds = { 'Git' },
  },
  {
    'wsdjeg/JavaUnit.vim',
    cmds = { 'JavaUnit' },
    build = { 'javac', '-encoding', 'utf8', '-d', 'bin', 'src/com/wsdjeg/util/*.java' },
    depends = {
      {
        'wsdjeg/syntastic',
      },
    },
  },
  {
    'D:/wsdjeg/winbar2.nvim',
  },
  {
    'wsdjeg/vim-async-dict',
    frozen = true,
  },
  {
    'wsdjeg/scrollbar.vim',
    events = { 'VimEnter' },
    config = function() end,
  },
  {
    'mhinz/vim-startify',
  },
  {
    'vim-airline/vim-airline',
  },
  {
    'vim-airline/vim-airline-themes',
  },
  {
    'preservim/nerdtree',
  },
  {
    'rakr/vim-one',
    config = function()
      vim.cmd('colorscheme one')
    end,
    priority = 100,
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
require('plug').load()
vim.cmd('nmap f <Plug>(clever-f-f)')
