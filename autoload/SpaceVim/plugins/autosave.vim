"=============================================================================
" autosave.vim --- autosave plugin for spacevim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" this plugin is inspired from:
" https://github.com/907th/vim-auto-save
" https://github.com/Pocco81/AutoSave.nvim
" https://github.com/chrisbra/vim-autosave


let s:default_opt = {
      \ 'timeoutlen' : 60*5*1000,
      \ 'backupdir' : '~/.cache/SpaceVim/backup/',
      \ 'event' : ['InsertLeave', 'TextChanged']
      \ }



function! SpaceVim#plugins#autosave#config(opt) abort

  

endfunction

function! s:save_buffer(bufnr) abort
  if !bufexists(a:bufnr)
    return
  endif
  if !getbufvar(a:bufnr, '&modified') ||
  \  !empty(getbufvar(a:bufnr, '&buftype')) ||
  \  getbufvar(a:bufnr, 'autosave_disabled', 0)
      return
  endif
endfunction
