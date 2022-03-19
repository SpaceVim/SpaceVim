"=============================================================================
" scrollbar.vim --- scrollbar support for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:VIM = SpaceVim#api#import('vim')
let s:BUF = SpaceVim#api#import('vim#buffer')
let s:WIN = SpaceVim#api#import('vim#window')

scriptencoding utf-8

let s:default = {
      \    'max_size' : 10,
      \    'min_size' : 3,
      \    'width' : 1,
      \    'right_offset' : 1,
      \    'excluded_filetypes' : ['startify'],
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

augroup spacevim_scrollbar
  autocmd!
augroup END


" vim script do not support metatable function

function! s:get(key) abort
  let val = get(g:, 'scrollbar_' . a:key, v:null)
  if val ==# v:null
    return s:default[a:key]
  endif
  if s:VIM.is_dict(val)
    let val = extend(val, s:default[a:key], 'keep')
  endif
  return val
endfunction


let s:ns_id = nvim_create_namespace('scrollbar')


function! s:gen_bar_lines(size) abort
  let shape = s:get('shape')
  let lines = [shape.head]
  for _ in range(2, a:size - 1)
    call add(lines, shape.body)
  endfor
  call add(lines, shape.tail)
  return lines
endfunction


function! s:fix_size(size) abort
  return max([s:get('min_size'), min([s:get('max_size'), a:size])])
endfunction


function! s:buf_get_var(bufnr, name) abort
  try
    let var = nvim_buf_get_var(a:bufnr, a:name)
    return var
  catch

  endtry
endfunction

function! s:add_highlight(bufnr, size) abort
  let highlight = s:get('highlight')
  call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.head, 0, 0, -1)
  for i in range(1, a:size - 2)
    call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.body, i, 0, -1)
  endfor
  call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.tail, a:size - 1, 0, -1)
endfunction

let s:next_index = 0
function! s:next_buf_index() abort
  let s:next_index += 1
  return s:next_index - 1
endfunction

function! s:create_buf(size, lines) abort
  noautocmd let bufnr = s:BUF.create_buf(0, 1)
  noautocmd call nvim_buf_set_option(bufnr, 'filetype', 'scrollbar')
  " noautocmd call nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  noautocmd call nvim_buf_set_name(bufnr, 'scrollbar_' . s:next_buf_index())
  noautocmd call nvim_buf_set_lines(bufnr, 0, a:size, 0, a:lines)
  call s:add_highlight(bufnr, a:size)
  " exe printf('au spacevim_scrollbar BufDelete <buffer=%s>  call SpaceVim#plugins#scrollbar#clear()', bufnr)
  return bufnr
endfunction

function! SpaceVim#plugins#scrollbar#show(...) abort
  let winnr = get(a:000, 0, 0)
  let bufnr = get(a:000, 1, 0)
  let win_config = nvim_win_get_config(winnr)

  " ignore other floating windows
  if win_config.relative !=# ''
    return
  endif

  let excluded_filetypes = s:get('excluded_filetypes')
  let filetype = nvim_buf_get_option(bufnr, 'filetype')

  if filetype == '' || index(excluded_filetypes, filetype) !=# -1
    return
  endif

  let total = line('$')
  let height = nvim_win_get_height(winnr)
  if total <= height
    call SpaceVim#plugins#scrollbar#clear()
    return
  endif

  let cursor = nvim_win_get_cursor(winnr)
  let curr_line = cursor[0]
  let bar_size = height * height / total
  let bar_size = s:fix_size(bar_size)

  let width = nvim_win_get_width(winnr)
  let col = width - s:get('width') - s:get('right_offset')
  let row = (height - bar_size) * (curr_line * 1.0  / total)

  let opts = {
        \  'style' : 'minimal',
        \  'relative' : 'win',
        \  'win' : winnr,
        \  'width' : s:get('width'),
        \  'height' : bar_size,
        \  'row' : row,
        \  'col' : col,
        \  'focusable' : 0,
        \ }
  let [bar_winnr, bar_bufnr] = [0, 0]
  let state = s:buf_get_var(bufnr, 'scrollbar_state')
  if !empty(state)
    let bar_bufnr = state.bufnr
    if has_key(state, 'winnr') && win_id2win(state.winnr) > 0
      let bar_winnr = state.winnr
    else
      noautocmd let bar_winnr = nvim_open_win(bar_bufnr, 0, opts)
    endif
    if state.size !=# bar_size
      noautocmd call nvim_buf_set_lines(bar_bufnr, 0, -1, 0, [])
      let bar_lines = s:gen_bar_lines(bar_size)
      noautocmd call nvim_buf_set_lines(bar_bufnr, 0, bar_size, 0, bar_lines)
      noautocmd call s:add_highlight(bar_bufnr, bar_size)
    endif
    noautocmd call nvim_win_set_config(bar_winnr, opts)
  else
    let bar_lines = s:gen_bar_lines(bar_size)
    let bar_bufnr = s:create_buf(bar_size, bar_lines)
    let bar_winnr = nvim_open_win(bar_bufnr, 0, opts)
    call nvim_win_set_option(bar_winnr, 'winhl', 'Normal:ScrollbarWinHighlight')
  endif
  call nvim_buf_set_var(bufnr, 'scrollbar_state', {
        \ 'winnr' : bar_winnr,
        \ 'bufnr' : bar_bufnr,
        \ 'size'  : bar_size,
        \ })
  return [bar_winnr, bar_bufnr]

endfunction

" the first argument is buffer number

function! SpaceVim#plugins#scrollbar#clear(...) abort
  let bufnr = get(a:000, 0, 0)
  let state = s:buf_get_var(bufnr, 'scrollbar_state')
  if !empty(state) && has_key(state, 'winnr')
    if win_id2win(state.winnr) > 0
      noautocmd call nvim_win_close(state.winnr, 1)
    endif
    noautocmd call nvim_buf_set_var(bufnr, 'scrollbar_state', {
          \ 'size' : state.size,
          \ 'bufnr' : state.bufnr,
          \ })
  endif

endfunction

