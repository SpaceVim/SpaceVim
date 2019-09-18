"=============================================================================
" buffer.vim --- SpaceVim buffer API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section vim#buffer, api-vim-buffer
" @parentsection api
" @subsection Functions
"
" is_cmdwin()
" 
" Check if current windows is command line windows.
" 
" open(opt)
"
" Open a new buffer with specifice options, return the buffer number, the {opt} 
" is a dict with following keys:
" 
"     bufname : the buffer name of the new buffer
"
"     mode: how to open the new buffer, default is vertical topleft split
"
"     initfunc: the function which will be call after creating buffer
"
"     cmd: the ex command which will be run after the new buffer is created


let s:self = {}


if exists('*getcmdwintype')
  function! s:self.is_cmdwin() abort
    return getcmdwintype() !=# ''
  endfunction
else
  function! s:self.is_cmdwin() abort
    return bufname('%') ==# '[Command Line]'
  endfunction
endif

function! s:self.open(opts) abort
  let buf = get(a:opts, 'bufname', '')
  let mode = get(a:opts, 'mode', 'vertical topleft split')
  let Initfunc = get(a:opts, 'initfunc', '')
  let cmd = get(a:opts, 'cmd', '')
  if empty(buf)
    exe mode | enew
  else
    exe mode buf
  endif
  if !empty(Initfunc)
    call call(Initfunc, [])
  endif

  if !empty(cmd)
    exe cmd
  endif
  return bufnr('%')
endfunction


func! s:self.resize(size, ...) abort
  let cmd = get(a:000, 0, 'vertical')
  exe cmd 'resize' a:size
endf

function! s:self.listed_buffers() abort
  return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction


function! s:self.filter_do(expr) abort
  let buffers = range(1, bufnr('$'))
  for f_expr in a:expr.expr
    let buffers = filter(buffers, f_expr)
  endfor
  for b in buffers
    exe printf(a:expr.do, b)
  endfor
endfunction


" just same as nvim_buf_set_lines
function! s:self.buf_set_lines(buffer, start, end, strict_indexing, replacement) abort
  let ma = getbufvar(a:buffer, '&ma')
  call setbufvar(a:buffer,'&ma', 1)
  if exists('*nvim_buf_set_lines')
    call nvim_buf_set_lines(a:buffer, a:start, a:end, a:strict_indexing, a:replacement)
  elseif has('python')
    py import vim
    py import string
    if bufexists(a:buffer)
      py bufnr = int(vim.eval("a:buffer"))
      py start_line = int(vim.eval("a:start"))
      py end_line = int(vim.eval("a:end"))
      py lines = vim.eval("a:replacement")
      py vim.buffers[bufnr][start_line:end_line] = lines
    endif
  elseif has('python3')
    py3 import vim
    py3 import string
    if bufexists(a:buffer)
      py3 bufnr = int(vim.eval("a:buffer"))
      py3 start_line = int(vim.eval("a:start"))
      py3 end_line = int(vim.eval("a:end"))
      py3 lines = vim.eval("a:replacement")
      py3 vim.buffers[bufnr][start_line:end_line] = lines
    endif
  elseif exists('*setbufline')
    let line = a:start
    for i in range(len(a:replacement))
      call setbufline(bufname(a:buffer), line + i, a:replacement[i])
    endfor
  else
    exe 'b' . a:buffer
    call setline(a:start - 1, a:replacement)
  endif
  call setbufvar(a:buffer,'&ma', ma)
endfunction


function! s:self.displayArea() abort
  return [
        \ line('w0'), line('w$')
        \ ]
endfunction


fu! SpaceVim#api#vim#buffer#get() abort
  return deepcopy(s:self)
endf
