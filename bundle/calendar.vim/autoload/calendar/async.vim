" =============================================================================
" Filename: autoload/calendar/async.vim
" Author: itchyny
" License: MIT License
" Last Change: 2016/11/27 09:07:11.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:use_timer = has('timers') && (v:version >= 800 || has('nvim'))

" Register a command to be executed asyncronously. Commands are executed using
"   - timers if available
"   - CursorHold recursion otherwise
" Optional argument: Allow duplication of commands.
function! calendar#async#new(command, ...) abort
  if !exists('b:calendar_async')
    let b:calendar_async = []
  endif
  if len(b:calendar_async) == 0
    if s:use_timer
      call timer_start(200, 'calendar#async#call')
      execute 'augroup CalendarAsync' . bufnr('')
        autocmd!
        autocmd BufEnter,WinEnter <buffer> call calendar#async#call()
      augroup END
    else
      execute 'augroup CalendarAsync' . bufnr('')
        autocmd!
        autocmd CursorHold <buffer> call calendar#async#call()
        autocmd BufEnter <buffer> call calendar#async#set_updatetime()
        autocmd BufLeave <buffer> call calendar#async#restore_updatetime()
        call calendar#async#set_updatetime()
      augroup END
    endif
  endif
  let i = 0
  for [c, num, dup] in b:calendar_async
    if c ==# a:command
      let i += 1
      if i > 2 * (a:0 && a:1) || !a:0
        return
      endif
    endif
  endfor
  call add(b:calendar_async, [a:command, 0, a:0 && a:1])
endfunction

" Set updatetime for the calendar buffer.
function! calendar#async#set_updatetime() abort
  if !has_key(b:, 'calendar_set_updatetime') || !b:calendar_set_updatetime
    let s:updatetime = &updatetime
    let &updatetime = calendar#setting#get('updatetime')
  endif
  let b:calendar_set_updatetime = 1
endfunction

" Restore updatetime.
function! calendar#async#restore_updatetime() abort
  if has_key(s:, 'updatetime')
    let &updatetime = s:updatetime
  endif
  let b:calendar_set_updatetime = 0
endfunction

" Execute the registered commands.
" Ignore the timer argument (optional for CursorHold recursion).
function! calendar#async#call(...) abort
  if !exists('b:calendar_async')
    return
  endif
  if !s:use_timer && exists('b:calendar_async_reltime') && has('reltime')
    let time = split(split(reltimestr(reltime(b:calendar_async_reltime)))[0], '\.')
    if time[0] ==# '0' && len(time[1]) && time[1][0] ==# '0'
      silent call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>" . (v:count ? v:count : ''), 'n')
      return
    endif
  endif
  let del = []
  let done = {}
  let cnt = 0
  let len = len(b:calendar_async)
  for i in range(len)
    let expression = b:calendar_async[i][0]
    if has_key(done, expression)
      call add(del, i)
      continue
    endif
    if cnt > 1 && !b:calendar_async[i][2]
      continue
    endif
    let done[expression] = 1
    let cnt += 1
    let ret = eval(expression)
    let b:calendar_async[i][1] += 1
    if !ret || b:calendar_async[i][1] > 100
      call add(del, i)
    endif
  endfor
  for i in reverse(del)
    call remove(b:calendar_async, i)
  endfor
  if !s:use_timer && has('reltime')
    let b:calendar_async_reltime = reltime()
  endif
  if len(b:calendar_async)
    if s:use_timer
      call timer_start(200, 'calendar#async#call')
    else
      silent call feedkeys(mode() ==# 'i' ? "\<C-g>\<ESC>" : "g\<ESC>" . (v:count ? v:count : ''), 'n')
    endif
  else
    execute 'autocmd! CalendarAsync' . bufnr('')
    if !s:use_timer
      call calendar#async#restore_updatetime()
    endif
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
