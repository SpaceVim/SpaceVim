" =============================================================================
" Filename: autoload/calendar/timestamp.vim
" Author: itchyny
" License: MIT License
" Last Change: 2020/11/19 07:41:09.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Save time stamps, not so that too many downloading requests occurs.
" This is used in google/task.vim and google/calendar.vim.

let s:cache = calendar#cache#new('timestamp')

function! calendar#timestamp#update(name, sec) abort
  let cache = s:cache.get(a:name)
  if type(cache) == type({})
        \ && has_key(cache, 'name') && cache.name ==# a:name
        \ && has_key(cache, 'day') && type(cache.day) == type([]) && len(cache.day) == 3
        \ && has_key(cache, 'time') && type(cache.time) == type([]) && len(cache.time) == 3
    let daydiff = calendar#day#today().sub(call('calendar#day#new', cache.day))
    let timediff = calendar#time#now().sub(call('calendar#time#new', cache.time))
    let refresh = timediff + daydiff * 86400 >= a:sec
  else
    let refresh = 1
  endif
  if refresh
    call s:cache.save(a:name,
          \ { 'name': a:name
          \ , 'day' : calendar#day#today().get_ymd()
          \ , 'time': calendar#time#now().get_hms() })
  endif
  return refresh
endfunction

function! calendar#timestamp#clear() abort
  call s:cache.clear()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
