"=============================================================================
" tasks.vim --- tasks support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:TOML = SpaceVim#api#import('data#toml')
let s:JSON = SpaceVim#api#import('data#json')
let s:FILE = SpaceVim#api#import('file')
let s:CMP = SpaceVim#api#import('vim#compatible')

" task object

let s:self = {}
let s:conf = []
let s:bufnr = -1


function! s:load() abort
      let s:conf = s:TOML.parse_file('.SpaceVim.d/tasks.toml')
endfunction

function! s:pick() abort
  
endfunction

function! SpaceVim#plugins#tasks#get()
  return s:pick()
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" list all the tasks
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! SpaceVim#plugins#tasks#list()

  call s:open_tasks_list_win()
  

endfunction


function! SpaceVim#plugins#tasks#complete(...)

  

endfunction


function! s:open_tasks_list_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __tasks_info__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist nomodifiable
        \ noswapfile
        \ nowrap
        \ cursorline
        \ nospell
        \ nonu
        \ norelativenumber
        \ winfixheight
        \ nomodifiable
  set filetype=SpaceVimTasksInfo
  let s:bufnr = bufnr('%')
endfunction
