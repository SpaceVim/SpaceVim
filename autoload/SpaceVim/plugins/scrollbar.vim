"=============================================================================
" scrollbar.vim --- scrollbar support for SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

scriptencoding utf-8

let s:default = {
      \    'max_size' : 10,
      \    'min_size' : 3,
      \    'width' : 1,
      \    'right_offset' : 1,
      \    'excluded_filetypes' : {},
      \    'shape' : {
      \        'head' : '▲',
      \        'body' : '█',
      \        'tail' : '▼',
      \    },
      \    'highlight' : {
      \        'head' : 'Normal',
      \        'body' : 'Normal',
      \        'tail' : 'Normal',
      \    }
      \ }


" vim script do not support metatable function

function! s:get(key) abort
  if !exists('g:scrollbar_' . a:key)
    return s:default[a:key]
  endif
endfunction


let s:ns_id = nvim_create_namespace('scrollbar')


function! s:add_highlight(bufnr, size) abort
  let highlight = s:get('highlight')
  call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.head, 0, 0, -1)
  for i in range(1, a:size - 2)
    call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.body, i, 0, -1)
  endfor
  call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.tail, a:size - 1, 0, -1)
endfunction

function! s:create_buf(size, lines) abort
  let bufnr = nvim_create_buf(0, 1)
  call nvim_buf_set_option(bufnr, 'filetype', 'scrollbar')
  call nvim_buf_set_name(bufnr, 'scrollbar_' .. next_buf_index())
  call nvim_buf_set_lines(bufnr, 0, a:size, 0, a:lines)

  call s:add_highlight(bufnr, a:size)
  return bufnr
endfunction

function! SpaceVim#plugins#scrollbar#clear() abort

  let bufnr = 0
  let state = getbufver(bufnr, 'scrollbar_state')

endfunction

