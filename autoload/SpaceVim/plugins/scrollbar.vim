"=============================================================================
" scrollbar.vim --- scrollbar support for SpaceVim
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section scrollbar, plugins-scrollbar
" @parentsection plugins
" The `scrollbar` plugin provides a scrollbar for current windows. There are
" two versions in SpaceVim.
"
" 1. Old version is written in Vim script for vim and < nvim 0.9.0
" 2. The new version is written in Lua, and require `has('nvim-0.9.0')`
" 
" This plugin is included in @section(layers-ui).

if has('nvim-0.9.0')
  function! SpaceVim#plugins#scrollbar#usable() abort
    return luaeval('require("spacevim.plugin.scrollbar").usable()')
  endfunction
  function! SpaceVim#plugins#scrollbar#show() abort
    lua require('spacevim.plugin.scrollbar').show()
  endfunction
  function! SpaceVim#plugins#scrollbar#clear(...) abort
    lua require('spacevim.plugin.scrollbar').clear()
  endfunction
  finish
endif



let s:VIM = SpaceVim#api#import('vim')
let s:BUF = SpaceVim#api#import('vim#buffer')
let s:WIN = SpaceVim#api#import('vim#window')
if has('nvim')
  let s:FLOAT = SpaceVim#api#import('neovim#floating')
else
  let s:FLOAT = SpaceVim#api#import('vim#floating')
endif
let s:HI = SpaceVim#api#import('vim#highlight')
let s:LOG = SpaceVim#logger#derive('scrollbar')

scriptencoding utf-8

let s:default = {
      \    'max_size' : 10,
      \    'min_size' : 5,
      \    'width' : 1,
      \    'right_offset' : 1,
      \    'excluded_filetypes' : ['startify', 'git-commit','leaderf', 'NvimTree', 'tagbar', 'defx', 'neo-tree', 'qf'],
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

let s:scrollbar_bufnr = -1
let s:scrollbar_winid = -1
let s:scrollbar_size = -1

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
  return float2nr(max([s:get('min_size'), min([s:get('max_size'), a:size])]))
endfunction

function! s:create_scrollbar_buffer(size, lines) abort
  if !bufexists(s:scrollbar_bufnr)
    let s:scrollbar_bufnr = s:BUF.create_buf(0, 1)
  endif
  call s:BUF.buf_set_lines(s:scrollbar_bufnr, 0, -1, 0, a:lines)
  call s:add_highlight(s:scrollbar_bufnr, a:size)
  call setbufvar(s:scrollbar_bufnr, '&buftype', 'nofile')
  return s:scrollbar_bufnr
endfunction

function! SpaceVim#plugins#scrollbar#show() abort
  let saved_ei = &eventignore
  let &ei = 'all'
  let [winnr, bufnr, winid] = [winnr(), bufnr(), win_getid()]
  if s:WIN.is_float(winid)
    call SpaceVim#plugins#scrollbar#clear()
    let &ei = saved_ei
    return
  endif

  let excluded_filetypes = s:get('excluded_filetypes')
  if &filetype == '' || index(excluded_filetypes, &filetype) !=# -1
    call SpaceVim#plugins#scrollbar#clear()
    let &ei = saved_ei
    return
  endif

  let total = line('$')
  let height = winheight(winnr)
  if total <= height
    call SpaceVim#plugins#scrollbar#clear()
    let &ei = saved_ei
    return
  endif

  " the position should be based on first line of current screen.
  let curr_line = line('w0')
  let bar_size = s:fix_size(height * height / total)

  let width = winwidth(winnr)
  let col = width - s:get('width') - s:get('right_offset')
  " first, you need to know the precision
  let precision = height - bar_size
  let each_line = (total - height) * 1.0 / precision
  let visble_line = min([curr_line, total - height + 1])
  if each_line >= 1
    let row = float2nr(visble_line / each_line)
  else
    let row = float2nr(visble_line / each_line - 1 / each_line)
  endif

  let opts = {
        \  'style' : 'minimal',
        \  'relative' : 'win',
        \  'win' : winid,
        \  'width' : s:get('width'),
        \  'height' : bar_size,
        \  'row' : row,
        \  'col' : float2nr(col),
        \  'focusable' : 0,
        \ }
  if has('nvim-0.5.0')
    let opts.zindex = 10
  endif
  if s:WIN.is_float(s:scrollbar_winid)
    if bar_size !=# s:scrollbar_size
      let s:scrollbar_size = bar_size
      let bar_lines = s:gen_bar_lines(bar_size)
      call s:BUF.buf_set_lines(s:scrollbar_bufnr, 0, -1, 0, bar_lines)
      call s:add_highlight(s:scrollbar_bufnr, bar_size)
    endif
    noautocmd call s:FLOAT.win_config(s:scrollbar_winid, opts)
  else
    let s:scrollbar_size = bar_size
    let bar_lines = s:gen_bar_lines(bar_size)
    let s:scrollbar_bufnr = s:create_scrollbar_buffer(bar_size, bar_lines)
    let s:scrollbar_winid = s:FLOAT.open_win(s:scrollbar_bufnr, 0, opts)
    if exists('&winhighlight')
      call setwinvar(win_id2win(s:scrollbar_winid), '&winhighlight', 'Normal:ScrollbarWinHighlight')
    endif
  endif
  let &ei = saved_ei
endfunction

" the first argument is buffer number

function! SpaceVim#plugins#scrollbar#clear(...) abort
  if s:WIN.is_float(s:scrollbar_winid)
    call s:FLOAT.win_close(s:scrollbar_winid, 1)
  endif
endfunction
