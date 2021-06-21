"=============================================================================
" trouble.vim --- trouble viewer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8


let s:icons = {
      \ 'fold_open' : '',
      \ 'fold_closed' : ''
      \ }

let s:troubles = {}

function! SpaceVim#plugins#trouble#open() abort

  call s:open_win()

endfunction

" open viewer windows
let s:bufnr = 0

function! s:open_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __trouble_manager__
  " @todo add win_getid api
  let s:winid = win_getid(winnr('#'))
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimTodoManager
  let s:bufnr = bufnr('%')
  call s:update_trouble_content()
  augroup spacevim_plugin_todo
    autocmd! * <buffer>
    autocmd WinEnter <buffer> call s:WinEnter()
  augroup END
  nnoremap <buffer><silent> <Enter> :call <SID>open_trouble()<cr>
endfunction

function! s:update_trouble_content() abort
  
endfunction
