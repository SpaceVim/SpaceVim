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
})

require('plug').add({
  {
    'wsdjeg/SourceCounter.vim',
    cmds = { 'SourceCounter' },
  },
  {
    type = 'raw',
    url = 'https://gist.githubusercontent.com/wsdjeg/4ac99019c5ca156d35704550648ba321/raw/4e8c202c74e98b5d56616c784bfbf9b873dc8868/markdown.vim',
    script_type = 'after/syntax'
  },
  {
    'wsdjeg/git.vim',
    cmds = { 'Git' },
  },
  {
    'wsdjeg/JavaUnit.vim',
    cmds = { 'JavaUnit' },
    build = {'javac', '-encoding', 'utf8', '-d', 'bin', 'src/com/wsdjeg/util/*.java'},
    depends = {
      {
        'wsdjeg/syntastic'
      }
    }
  },
  {
    'wsdjeg/vim-async-dict',
    build = 'cargo build',
    frozen = true,
  },
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
