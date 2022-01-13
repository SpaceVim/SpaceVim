"=============================================================================
" vim.vim --- vim api for SpaceVim
" Copyright (c) 2016-2021 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


let s:self = {}
let s:self.__cmp = SpaceVim#api#import('vim#compatible')
let s:self.__string = SpaceVim#api#import('data#string')

function! s:self.jumps() abort
  let result = []
  for jump in split(self.__cmp.execute('jumps'), '\n')[1:]
    let list = split(jump)
    if len(list) < 4
      continue
    endif

    let [linenr, col, file_text] = [list[1], list[2]+1, join(list[3:])]
    let lines = getbufline(file_text, linenr)
    let path = file_text
    let bufnr = bufnr(file_text)
    if empty(lines)
      if stridx(join(split(getline(linenr))), file_text) == 0
        let lines = [file_text]
        let path = bufname('%')
        let bufnr = bufnr('%')
      elseif filereadable(path)
        let bufnr = 0
        let lines = ['buffer unloaded']
      else
        " Skip.
        continue
      endif
    endif

    if getbufvar(bufnr, '&filetype') ==# 'unite'
      " Skip unite buffer.
      continue
    endif

    call add(result, [linenr, col, file_text, path, bufnr, lines])
  endfor
  return result
endfunction

function! s:self.parse_string(line) abort
  let expr = '`[^`]*`'
  let i = 0
  let line = []
  while i < strlen(a:line) || i != -1
    let [rst, m, n] = self.__string.matchstrpos(a:line, expr, i)
    if m == -1
      call add(line, a:line[ i : -1 ])
      break
    else
      call add(line, a:line[ i : m-1])
      try
        let rst = eval(rst[1:-2])
      catch
        let rst = ''
      endtry
      call add(line, rst)
    endif
    let i = n
  endwhile
  return join(line, '')
endfunction


function! s:self.setbufvar(buf, dict) abort
  for key in keys(a:dict)
    call setbufvar(a:buf, key, a:dict[key])
  endfor
endfunction


if exists('*nvim_win_set_cursor')
  function! s:self.win_set_cursor(win, pos) abort
    call nvim_win_set_cursor(a:win, a:pos)
  endfunction
elseif exists('*win_execute')
  function! s:self.win_set_cursor(win, pos) abort
    " @fixme use g` to move to cursor line
    " this seem to be a bug of vim
    " https://github.com/vim/vim/issues/5022
    call win_execute(a:win, ':call cursor(' . a:pos[0] . ', ' . a:pos[1] . ')')
    " call win_execute(a:win, ':' . a:pos[0])
    call win_execute(a:win, ':normal! g"')
  endfunction
elseif has('lua')
" @vimlint(EVL103, 1, a:win)
" @vimlint(EVL103, 1, a:pos)
  function! s:self.win_set_cursor(win, pos) abort
    lua local winindex = vim.eval("win_id2win(a:win) - 1")
    lua local w = vim.window(winindex)
    lua w.line = vim.eval("a:pos[0]")
    lua w.col = vim.eval("a:pos[1]")
  endfunction
else
  function! s:self.win_set_cursor(win, pos) abort

  endfunction
" @vimlint(EVL103, 0, a:win)
" @vimlint(EVL103, 0, a:pos)
endif

if exists('*nvim_buf_line_count')
  function! s:self.buf_line_count(buf) abort
    return nvim_buf_line_count(a:buf)
  endfunction
elseif has('lua')
  " @vimlint(EVL103, 1, a:buf)
  function! s:self.buf_line_count(buf) abort
    " lua numbers are floats, so use float2nr
    return float2nr(luaeval('#vim.buffer(vim.eval("a:buf"))'))
  endfunction
  " @vimlint(EVL103, 0, a:buf)
else
  function! s:self.buf_line_count(buf) abort
    return len(getbufline(a:buf, 1, '$'))
  endfunction
endif

function! s:self.setbufvar(buf, dict) abort
  for key in keys(a:dict)
    call setbufvar(a:buf, key, a:dict[key])
  endfor
endfunction

" https://vi.stackexchange.com/questions/16585/how-to-differentiate-quickfix-window-buffers-and-location-list-buffers
if has('patch-7.4-2215') " && exists('*getwininfo')
  function! s:self.get_qf_winnr() abort
    let wins = filter(getwininfo(), 'v:val.quickfix && !v:val.loclist')
    " assert(len(wins) <= 1)
    return empty(wins) ? 0 : wins[0].winnr
  endfunction
else
  function! s:self.get_qf_winnr() abort
    let buffers = split(self.__cmp.execute('ls!'), "\n")
    call filter(buffers, 'v:val =~# "\\V[Quickfix List]"')
    " :cclose removes the buffer from the list (in my config only??)
    " assert(len(buffers) <= 1)
    return empty(buffers) ? 0 : eval(matchstr(buffers[0], '\v^\s*\zs\d+'))
  endfunction
endif

function! s:self.is_qf_win(winnr) abort
  return a:winnr ==# self.get_qf_winnr()
endfunction

function! s:self.is_number(var) abort
  return type(a:var) ==# 0
endfunction

function! s:self.is_string(var) abort
  return type(a:var) ==# 1
endfunction

function! s:self.is_func(var) abort
  return type(a:var) ==# 2
endfunction

function! s:self.is_list(var) abort
  return type(a:var) ==# 3
endfunction

function! s:self.is_dict(var) abort
  return type(a:var) ==# 4
endfunction

function! s:self.is_float(var) abort
  return type(a:var) ==# 5
endfunction

function! s:self.is_bool(var) abort
  return type(a:var) ==# 6
endfunction

function! s:self.is_none(var) abort
  return type(a:var) ==# 7
endfunction

function! s:self.is_job(var) abort
  return type(a:var) ==# 8
endfunction

function! s:self.is_channel(var) abort
  return type(a:var) ==# 9
endfunction

function! s:self.is_blob(var) abort
  return type(a:var) ==# 10
endfunction

if has('nvim')
  function! s:self.getchar(...) abort
    if !empty(get(g:, '_spacevim_input_list', []))
      return remove(g:_spacevim_input_list, 0)
    endif
    let ret = call('getchar', a:000)
    return (type(ret) == type(0) ? nr2char(ret) : ret)
  endfunction
else
  function! s:self.getchar(...) abort
    if !empty(get(g:, '_spacevim_input_list', []))
      return remove(g:_spacevim_input_list, 0)
    endif
    let ret = call('getchar', a:000)
    while ret ==# "\x80\xfd\d"
      let ret = call('getchar', a:000)
    endwhile
    return (type(ret) == type(0) ? nr2char(ret) : ret)
  endfunction
endif

function! SpaceVim#api#vim#get() abort
  return deepcopy(s:self)
endfunction
