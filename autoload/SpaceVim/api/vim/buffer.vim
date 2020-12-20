"=============================================================================
" buffer.vim --- SpaceVim buffer API
" Copyright (c) 2016-2020 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section vim#buffer, api-vim-buffer
" @parentsection api
" @subsection Intro
"
" vim#buffer API provides some basic functions for setting and getting config
" of vim buffer.
"
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

" bufnr needs atleast one argv before patch-8.1.1924 has('patch-8.1.1924')
function! s:self.bufnr(...) abort
  if has('patch-8.1.1924')
    return call('bufnr', a:000)
  else
    if a:0 ==# 0
      return bufnr('%')
    else
      return call('bufnr', a:000)
    endif
  endif
endfunction


function! s:self.bufadd(name) abort
  if exists('*bufadd')
    return bufadd(a:name)
  elseif get(g:, '_spacevim_if_lua', 0) && empty(a:name)
    let nr = float2nr(luaeval('vim.open().number'))
    call setbufvar(nr, '&buflisted', 0)
    return nr
  elseif empty(a:name)
    " create an no-named buffer
    noautocmd 1new
    " bufnr needs atleast one argv before patch-8.1.1924 has('patch-8.1.1924')
    let nr = self.bufnr()
    setl nobuflisted
    noautocmd q
    return nr
  elseif bufexists(a:name)
    return bufnr(a:name)
  else
    exe 'noautocmd 1split ' . a:name
    let nr = self.bufnr()
    setl nobuflisted
    noautocmd q
    return nr
  endif
endfunction
if exists('*nvim_create_buf')
  function! s:self.create_buf(listed, scratch) abort
    return nvim_create_buf(a:listed, a:scratch)
  endfunction
else
  function! s:self.create_buf(listed, scratch) abort
    let bufnr = self.bufadd('')
    " in vim, a:listed must be number, what the fuck!
    " why can not use v:true and v:false
    call setbufvar(bufnr, '&buflisted', a:listed ? 1 : 0)
    if a:scratch
      call setbufvar(bufnr, '&swapfile', 0)
      call setbufvar(bufnr, '&bufhidden', 'hide')
      call setbufvar(bufnr, '&buftype', 'nofile')
    endif
    return bufnr
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

if exists('*nvim_buf_line_count')
  function! s:self.line_count(buf) abort
    return nvim_buf_line_count(a:buf)
  endfunction
elseif get(g:, '_spacevim_if_lua', 0)
  " @vimlint(EVL103, 1, a:buf)
  function! s:self.line_count(buf) abort
    " lua numbers are floats, so use float2nr
    return float2nr(luaeval('#vim.buffer(vim.eval("a:buf"))'))
  endfunction
  " @vimlint(EVL103, 0, a:buf)
else
  function! s:self.line_count(buf) abort
    return len(getbufline(a:buf, 1, '$'))
  endfunction
endif


" just same as nvim_buf_set_lines
function! s:self.buf_set_lines(buffer, start, end, strict_indexing, replacement) abort
  if !bufexists(a:buffer)
    return
  endif
  let ma = getbufvar(a:buffer, '&ma')
  call setbufvar(a:buffer,'&ma', 1)
  if exists('*nvim_buf_set_lines')
    call nvim_buf_set_lines(a:buffer, a:start, a:end, a:strict_indexing, a:replacement)
  elseif exists('*deletebufline') && exists('*bufload')
    " patch-8.1.0039 deletebufline()
    " patch-8.1.0037 appendbufline()
    " patch-8.0.1039 setbufline()
    " patch-8.1.1610 bufadd() bufload()
    let lct = self.line_count(a:buffer)
    if a:start > lct
      return
    elseif a:start >= 0 && a:end > a:start
      " in vim, setbufline will not load buffer automatically
      " but in neovim, nvim_buf_set_lines will do it.
      " @fixme vim issue #5044
      " https://github.com/vim/vim/issues/5044
      if !bufloaded(a:buffer)
        call bufload(a:buffer)
      endif
      " 0, 1 len = 1 a:replacement = 4
      if len(a:replacement) == a:end - a:start
        for i in range(a:start, a:end - 1)
          call setbufline(a:buffer, i + 1, a:replacement[i - a:start])
        endfor
      else
        let endtext = a:end >= lct ? [] : getbufline(a:buffer, a:end + 1, '$')
        let replacement = a:replacement + endtext
        for i in range(a:start, len(replacement) + a:start - 1)
          call setbufline(a:buffer, i + 1, replacement[i - a:start])
        endfor
        call deletebufline(a:buffer,len(replacement) + a:start + 1, '$')
      endif
    elseif a:start >= 0 && a:end < 0 && lct + a:end >= a:start
      call self.buf_set_lines(a:buffer, a:start, lct + a:end + 1, a:strict_indexing, a:replacement)
    elseif a:start <= 0 && a:end > a:start && a:end < 0 && lct + a:start >= 0
      call self.buf_set_lines(a:buffer, lct + a:start + 1, lct + a:end + 2, a:strict_indexing, a:replacement)
    endif
  elseif has('python')
py << EOF
import vim
import string
bufnr = int(vim.eval("a:buffer"))
start_line = int(vim.eval("a:start"))
if start_line < 0:
    start_line = len(vim.buffers[bufnr]) + 1 + start_line
end_line = int(vim.eval("a:end"))
if end_line < 0:
    end_line = len(vim.buffers[bufnr]) + 1 + end_line
lines = vim.eval("a:replacement")
vim.buffers[bufnr][start_line:end_line] = lines
EOF
  elseif has('python3')
py3 << EOF
import vim
import string
bufnr = int(vim.eval("a:buffer"))
start_line = int(vim.eval("a:start"))
if start_line < 0:
    start_line = len(vim.buffers[bufnr]) + 1 + start_line
end_line = int(vim.eval("a:end"))
if end_line < 0:
    end_line = len(vim.buffers[bufnr]) + 1 + end_line
lines = vim.eval("a:replacement")
vim.buffers[bufnr][start_line:end_line] = lines
EOF
  elseif get(g:, '_spacevim_if_lua', 0) == 1
    " @todo add lua support
    silent! noautocmd lua require("spacevim.api.vim.buffer").set_lines(
          \ vim.eval("a:buffer"),
          \ vim.eval("a:start"),
          \ vim.eval("a:end"),
          \ vim.eval("a:replacement")
          \ )
  else
    exe 'b' . a:buffer
    let lct = line('$')
    if a:start > lct
      return
    elseif a:start >= 0 && a:end > a:start
      let endtext = a:end > lct ? [] : getline(a:end + 1, '$')
      " 0 start end $
      if len(a:replacement) == a:end - a:start
        for i in range(a:start, len(a:replacement) + a:start - 1)
          call setline(i + 1, a:replacement[i - a:start])
        endfor
      else
        let replacement = a:replacement + endtext
        for i in range(a:start, len(replacement) + a:start - 1)
          call setline(i + 1, replacement[i - a:start])
        endfor
      endif
    elseif a:start >= 0 && a:end < 0 && lct + a:end > a:start
      call self.buf_set_lines(a:buffer, a:start, lct + a:end + 1, a:strict_indexing, a:replacement)
    elseif a:start <= 0 && a:end > a:start && a:end < 0 && lct + a:start >= 0
      call self.buf_set_lines(a:buffer, lct + a:start + 1, lct + a:end + 1, a:strict_indexing, a:replacement)
    endif
  endif
  call setbufvar(a:buffer,'&ma', ma)
endfunction


function! s:self.displayArea() abort
  return [
        \ line('w0'), line('w$')
        \ ]
endfunction

function! s:self.add_highlight(bufnr, hl, line, col, long) abort
  if exists('*nvim_buf_add_highlight')
    call nvim_buf_add_highlight(a:bufnr, 0, a:hl, a:line, a:col, a:col + a:long)
  else
    call SpaceVim#logger#warn('vim#buffer.add_highlight api only support neovim', 0)
  endif
endfunction

function! s:self.buf_get_lines(bufnr, start, end, strict_indexing) abort
  if exists('*nvim_buf_get_lines')
    return nvim_buf_get_lines(a:bufnr, a:start, a:end, a:strict_indexing)
  elseif exists('*getbufline') && exists('*bufload') && exists('*bufloaded')
    let lct = self.line_count(a:bufnr)
    if a:start > lct
      return
    elseif a:start >= 0 && a:end > a:start
      " in vim, getbufline will not load buffer automatically
      " but in neovim, nvim_buf_set_lines will do it.
      " @fixme vim issue #5044
      " https://github.com/vim/vim/issues/5044
      if !bufloaded(a:bufnr)
        call bufload(a:bufnr)
      endif
      return getbufline(a:bufnr, a:start + 1, a:end)
    elseif a:start >= 0 && a:end < 0 && lct + a:end >= a:start
      return self.buf_get_lines(a:bufnr, a:start, lct + a:end + 1, a:strict_indexing)
    elseif a:start <= 0 && a:end > a:start && a:end < 0 && lct + a:start >= 0
      return self.buf_get_lines(a:bufnr, lct + a:start + 1, lct + a:end + 2, a:strict_indexing)
    endif
  endif
endfunction


fu! SpaceVim#api#vim#buffer#get() abort
  return deepcopy(s:self)
endf
