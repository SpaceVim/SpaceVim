"=============================================================================
" quickfix.vim --- quickfix for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" this is a build-in quickfix list and location list plugin for SpaceVim, and
" it should works well for both quickfix list and location list. The public
" key bindings is:
" 1. jump to next position in qflist
" 2. jump to previous position in qflist
" 3. open qflist if it is available

let s:qflist = []

let s:qf_title = ''

let s:filestack = []

let s:qf_index = 0

let s:qf_bufnr = -1

" like setqflist()


function! SpaceVim#plugins#quickfix#setqflist(list, ...) abort
  let action = get(a:000, 0, ' ')
  if action ==# 'a'
    call extend(s:qflist, a:list)
  elseif action ==# 'r'
    let s:qflist = a:list
  elseif empty(action) || action ==# ' '
    let s:qflist = a:list
  else
    echohl Error
    echo 'wrong args for SpaceVim setqflist: ' . action
    echohl NONE
  endif
  let what = get(a:000, 1, {})
  if has_key(what, 'title')
    let s:qf_title = what.title
  endif
endfunction


function! SpaceVim#plugins#quickfix#getqflist() abort

  return s:qflist

endfunction


function! SpaceVim#plugins#quickfix#next() abort

  let s:qf_index += 1
  let file = get(s:filestack, s:qf_index, {})
  if !empty(file)
    wincmd p
    exe 'e' file.name
    exe file.lnum
  endif

endfunction


function! SpaceVim#plugins#quickfix#pre() abort

  let s:qf_index -= 1
  let file = get(s:filestack, s:qf_index, {})
  if !empty(file)
    wincmd p
    exe 'e' file.name
    exe file.lnum
  endif

endfunction


function! SpaceVim#plugins#quickfix#enter() abort
  let s:qf_index = line('.') - 1
  let file = get(s:filestack, s:qf_index, {})
  if !empty(file)
    wincmd p
    exe 'e' file.name
    exe file.lnum
  endif
endfunction

let s:BUFFER = SpaceVim#api#import('vim#buffer')
function! SpaceVim#plugins#quickfix#openwin() abort
  call s:BUFFER.open({
        \ 'bufname' : '__quickfix__',
        \ 'cmd' : 'setl buftype=nofile bufhidden=wipe filetype=SpaceVimQuickFix nomodifiable nowrap nobuflisted',
        \ 'mode' : 'rightbelow split ',
        \ })
  let s:qf_bufnr = bufnr('%')
  call s:BUFFER.resize(10, '')
  call s:mappings()
  call s:update_stack()
  let lines = []
  for file in s:qflist
    let line = ''
    if has_key(file, 'abbr')
      let line .= file.abbr
    elseif has_key(file, 'filename')
      let line .= file.name
    elseif has_key(file, 'bufnr')
      let line .= bufname(file.bufnr)
    endif
    let line .= '  '
    if has_key(file, 'type')
      let line .= '|' . file.type . '|  '
    endif
    let line .= file.text
    call add(lines, line)
  endfor
  call setbufvar(bufnr('%'),'&ma', 1)
  call s:BUFFER.buf_set_lines(bufnr('%'), 0, len(lines) - 1, 0, lines)
  call setbufvar(bufnr('%'),'&ma', 0)
endfunction

function! s:mappings() abort
  nnoremap <buffer><silent> <cr> :call SpaceVim#plugins#quickfix#enter()<cr>
  nnoremap <buffer><silent> q :close<cr>
endfunction

function! s:update_stack() abort
  let s:filestack = []
  for item in s:qflist
    let file = {}
    if has_key(item, 'bufnr') && bufexists(item.bufnr)
      let file.name = bufname(item.bufnr)
    elseif has_key(item, 'bufname')
      let file.name = item.bufname
    elseif has_key(item, 'filename') 
      let file.name = item.filename
    else
      let file.name = ''
    endif
    let file.lnum = item.lnum
    let file.col = item.col
    call add(s:filestack, file)
  endfor
endfunction

function! SpaceVim#plugins#quickfix#swapqf() abort
  try
    cclose
  catch
  endtry
  call SpaceVim#plugins#quickfix#setqflist(getqflist())
  call SpaceVim#plugins#quickfix#openwin()
endfunction

" :cclose only close quickfix windows on current tab, this func can close all
" qucikfix windows in all tabs when pass an argv to this func.

function! SpaceVim#plugins#quickfix#closewin(...) abort
  let close_all = get(a:000, 1, 0)
  let has_qf = bufexists('__quickfix__')
  if !has_qf
    return
  endif
  if close_all
  else
    call s:close_qfwin()
  endif
endfunction

function! s:close_qfwin() abort
  let wr = bufwinnr(s:qf_bufnr)
  if wr > -1
    exe wr . 'wincmd w'
    close
  endif
endfunction
