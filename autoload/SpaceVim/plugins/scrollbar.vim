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
if has('nvim')
  let s:FLOAT = SpaceVim#api#import('neovim#floating')
else
  let s:FLOAT = SpaceVim#api#import('vim#floating')
endif
let s:HI = SpaceVim#api#import('vim#highlight')

scriptencoding utf-8

let s:default = {
      \    'max_size' : 10,
      \    'min_size' : 3,
      \    'width' : 1,
      \    'right_offset' : 1,
      \    'excluded_filetypes' : ['startify', 'leaderf'],
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

function! SpaceVim#plugins#scrollbar#usable() abort

  return s:FLOAT.exists()

endfunction

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


" this is only supported in neovim
if exists('*nvim_create_namespace')
  let s:ns_id = nvim_create_namespace('scrollbar')
  function! s:add_highlight(bufnr, size) abort
    let highlight = s:get('highlight')
    call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.head, 0, 0, -1)
    for i in range(1, a:size - 2)
      call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.body, i, 0, -1)
    endfor
    call nvim_buf_add_highlight(a:bufnr, s:ns_id, highlight.tail, a:size - 1, 0, -1)
  endfunction
else

  function! s:add_highlight(bufnr, size) abort
  endfunction
endif

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


let s:next_index = 0
function! s:next_buf_index() abort
  let s:next_index += 1
  return s:next_index - 1
endfunction

function! s:create_buf(size, lines) abort
  let name = 'scrollbar_' . s:next_buf_index()
  noautocmd let bufnr = s:BUF.bufadd(name)
  call setbufvar(bufnr, '&buflisted', 0)
  call setbufvar(bufnr, '&swapfile', 0)
  call setbufvar(bufnr, '&bufhidden', 'hide')
  call setbufvar(bufnr, '&buftype', 'nofile')
  noautocmd call setbufvar(bufnr, '&filetype', 'scrollbar')
  noautocmd call s:BUF.buf_set_lines(bufnr, 0, a:size, 0, a:lines)
  call s:add_highlight(bufnr, a:size)
  return bufnr
endfunction

function! SpaceVim#plugins#scrollbar#show() abort
  let [winnr, bufnr, winid] = [winnr(), bufnr(), win_getid()]
  if s:WIN.is_float(winnr)
    return
  endif

  let excluded_filetypes = s:get('excluded_filetypes')
  if &filetype == '' || index(excluded_filetypes, &filetype) !=# -1
    return
  endif

  let total = line('$')
  let height = winheight(winnr)
  if total <= height
    call SpaceVim#plugins#scrollbar#clear()
    return
  endif

  let pos = getpos('.')
  let curr_line = pos[1]
  let bar_size = height * height / total
  let bar_size = s:fix_size(bar_size)

  let width = winwidth(winnr)
  let col = width - s:get('width') - s:get('right_offset')
  let row = (height - bar_size) * (curr_line * 1.0  / total)

  let opts = {
        \  'style' : 'minimal',
        \  'relative' : 'win',
        \  'win' : winid,
        \  'width' : s:get('width'),
        \  'height' : float2nr(bar_size),
        \  'row' : float2nr(row),
        \  'col' : float2nr(col),
        \  'focusable' : 0,
        \ }
  let [bar_winnr, bar_bufnr] = [0, 0]
  let state = getbufvar(bufnr, 'scrollbar_state')
  if !empty(state)
    let bar_bufnr = state.bufnr
    if has_key(state, 'winnr') && win_id2win(state.winnr) > 0
      let bar_winnr = state.winnr
    else
      noautocmd let bar_winnr = s:FLOAT.open_win(bar_bufnr, 0, opts)
    endif
    if state.size !=# bar_size
      noautocmd call s:BUF.buf_set_lines(bar_bufnr, 0, -1, 0, [])
      let bar_lines = s:gen_bar_lines(bar_size)
      noautocmd call s:BUF.buf_set_lines(bar_bufnr, 0, bar_size, 0, bar_lines)
      noautocmd call s:add_highlight(bar_bufnr, bar_size)
    endif
    noautocmd call s:FLOAT.win_config(bar_winnr, opts)
  else
    let bar_lines = s:gen_bar_lines(bar_size)
    let bar_bufnr = s:create_buf(bar_size, bar_lines)
    let bar_winnr = s:FLOAT.open_win(bar_bufnr, 0, opts)
    if exists('&winhighlight')
      call setwinvar(bar_winnr, '&winhighlight', 'Normal:ScrollbarWinHighlight')
    endif
  endif
  call setbufvar(bufnr, 'scrollbar_state', {
        \ 'winnr' : bar_winnr,
        \ 'bufnr' : bar_bufnr,
        \ 'size'  : bar_size,
        \ })
  return [bar_winnr, bar_bufnr]

endfunction

" the first argument is buffer number

function! SpaceVim#plugins#scrollbar#clear(...) abort
  let bufnr = get(a:000, 0, 0)
  let state = getbufvar(bufnr, 'scrollbar_state')
  if !empty(state) && has_key(state, 'winnr')
    if win_id2win(state.winnr) > 0
      noautocmd call s:FLOAT.win_close(state.winnr, 1)
    endif
    noautocmd call setbufvar(bufnr, 'scrollbar_state', {
          \ 'size' : state.size,
          \ 'bufnr' : state.bufnr,
          \ })
  endif

endfunction

