function! s:SID() "{{{1
  let fullname = expand("<sfile>")
  return matchstr(fullname, '<SNR>\d\+_')
endfunction
"}}}
let s:sid = s:SID()

function! s:uniq(list) "{{{1
  let R = []
  for e in a:list
    if index(R, e) is -1
      call add(R, e)
    endif
  endfor
  return R
endfunction
"}}}

function! s:debug(msg) "{{{1
  if !get(g:,'choosewin_debug')
    return
  endif
  if exists('*Plog')
    call Plog(a:msg)
  endif
endfunction


function! s:buffer_options_set(bufnr, options) "{{{1
  let R = {}
  for [var, val] in items(a:options)
    let R[var] = getbufvar(a:bufnr, var)
    call setbufvar(a:bufnr, var, val)
    unlet var val
  endfor
  return R
endfunction

function! s:window_options_set(winnr, options) "{{{1
  let R = {}
  for [var, val] in items(a:options)
    let R[var] = getwinvar(a:winnr, var)
    call setwinvar(a:winnr, var, val)
    unlet var val
  endfor
  return R
endfunction
"}}}

" s:strchars() "{{{1
if exists('*strchars')
  function! s:strchars(str)
    return strchars(a:str)
  endfunction
else
  function! s:strchars(str)
    return strlen(substitute(str, ".", "x", "g"))
  endfunction
endif
"}}}

function! s:include_multibyte_char(str) "{{{1
  return strlen(a:str) !=# s:strchars(a:str)
endfunction

function! s:str_split(str) "{{{1
  return split(a:str, '\zs')
endfunction

function! s:define_type_checker() "{{{1
  " dynamically define s:is_Number(v)  etc..
  let types = {
        \ "Number":     0,
        \ "String":     1,
        \ "Funcref":    2,
        \ "List":       3,
        \ "Dictionary": 4,
        \ "Float":      5,
        \ }

  for [type, number] in items(types)
    let s = ''
    let s .= 'function! s:is_' . type . '(v)' . "\n"
    let s .= '  return type(a:v) is ' . number . "\n"
    let s .= 'endfunction' . "\n"
    execute s
  endfor
endfunction
"}}}
call s:define_type_checker()
unlet! s:define_type_checker

function! s:get_ic(table, char, ...) "{{{1
  let default = get(a:000, 0)
  " get() with ignore case
  let keys = keys(a:table)
  let i = index(keys, a:char, 0, 1)
  if i is -1
    return default
  endif
  return a:table[keys[i]]
endfunction

function! s:dict_invert(d) "{{{1
  return s:dict_create(values(a:d), keys(a:d))
endfunction

function! s:dict_create(keys, values) "{{{1
  " Create dict from two List.
  let R = {}
  for i in range(0, min([len(a:keys), len(a:values)]) - 1)
    let R[a:keys[i]] = a:values[i]
  endfor
  return R
endfunction

function! s:blink(count, color, pattern) "{{{1
  for i in range(a:count)
    let id = matchadd(a:color, a:pattern)
    redraw
    sleep 80m
    call matchdelete(id)
    redraw 
    sleep 80m
  endfor
endfunction

function! s:message(msg) "{{{1
  echohl Type
  echon 'choosewin: '
  echohl Normal
  echon a:msg
endfunction

function! s:read_char(prompt) "{{{1
  redraw
  echohl PreProc
  echon a:prompt
  echohl Normal
  return nr2char(getchar())
endfunction
"}}}

let s:functions = [
      \ "debug",
      \ "uniq",
      \ "dict_invert",
      \ "dict_create",
      \ "str_split",
      \ "buffer_options_set",
      \ "window_options_set",
      \ "strchars",
      \ "include_multibyte_char",
      \ "is_Number",
      \ "is_String",
      \ "is_Funcref",
      \ "is_List",
      \ "is_Dictionary",
      \ "is_Float",
      \ "get_ic",
      \ "blink",
      \ "message",
      \ "read_char",
      \ ]

function! choosewin#util#get() "{{{1
  let R = {}
  for fname in s:functions
    let R[fname] = function(s:sid . fname)
  endfor
  return R
endfunction
"}}}

" vim: foldmethod=marker
