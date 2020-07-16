"=============================================================================
" searcher.vim --- project searcher for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')

let s:rst = []

function! SpaceVim#plugins#searcher#find(expr, exe) abort
  if empty(a:expr)
    let expr = input('search expr: ')
    normal! :
  else
    let expr = a:expr
  endif
  let s:rst = []
  let id =  s:JOB.start(s:get_search_cmd(a:exe, expr), {
        \ 'on_stdout' : function('s:search_stdout'),
        \ 'on_stderr' : function('s:search_stderr'),
        \ 'in_io' : 'null',
        \ 'on_exit' : function('s:search_exit'),
        \ })
  if id > 0
    echohl Comment
    echo 'searching: ' . expr
    echohl None
  endif
endfunction
" @vimlint(EVL103, 1, a:id)
" @vimlint(EVL103, 1, a:event)
function! s:search_stdout(id, data, event) abort
  for data in a:data
    let info = split(data, '\:\d\+\:')
    if len(info) == 2
      let [fname, text] = info
      let lnum = matchstr(data, '\:\d\+\:')[1:-2]
      call add(s:rst, {
            \ 'filename' : fnamemodify(fname, ':p'),
            \ 'lnum' : lnum,
            \ 'text' : text,
            \ })
    endif
  endfor
endfunction

function! s:search_stderr(id, data, event) abort

endfunction

function! s:get_search_cmd(exe, expr) abort
  if a:exe ==# 'grep'
    return ['grep', '-inHR', '--exclude-dir', '.git', a:expr, '.']
  elseif a:exe ==# 'rg'
    return ['rg', '--hidden', '--no-heading', '--color=never', '--with-filename', '--line-number', a:expr, '.']
  else
    return [a:exe, a:expr]
  endif
endfunction

" @vimlint(EVL103, 1, a:data)
function! s:search_exit(id, data, event) abort
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
  call setqflist([], 'r', {'title': ' ' . len(s:rst) . ' items',
        \ 'items' : s:rst
        \ })
  botright copen
endfunction

" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:event)

function! SpaceVim#plugins#searcher#list() abort
  call setqflist([], 'r', {'title': ' ' . len(s:rst) . ' items',
        \ 'items' : s:rst
        \ })
  botright copen
endfunction

function! SpaceVim#plugins#searcher#count() abort
  if empty(s:rst)
    return ''
  else
    return ' ' . len(s:rst) . ' items '
  endif
endfunction
nnoremap <silent> <Plug>(nohlsearch) :nohlsearch<Cr>

function! SpaceVim#plugins#searcher#clear() abort
  call feedkeys("\<Plug>(nohlsearch)")
  let s:rst = []
  call setqflist([])
  let &l:statusline = SpaceVim#layers#core#statusline#get(1)
  cclose
  normal! :
endfunction

