" =============================================================================
" Filename: autoload/calendar.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:35:29.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Creates a new buffer and start calendar.
function! calendar#new(args) abort

  " Argument parsing
  let [isnewbuffer, command, variables, args] = calendar#argument#parse(a:args)

  " Open a new buffer.
  try | silent execute command | catch | return | endtry

  " Clear the previous syntaxes.
  silent! call b:calendar.clear()

  " Store the options which are given as the argument.
  let b:_calendar = variables

  " Start calendar.
  let b:calendar = calendar#controller#new()
  " Set time
  call b:calendar.set_time(calendar#time#now())
  " Set day and update the buffer.
  call b:calendar.go(calendar#argument#day(args, calendar#day#today().get_ymd()))

  " Save b:calendar and b:_calendar.
  call calendar#save()

endfunction

let s:calendar = {}
let s:_calendar = {}

" Save b:calendar and b:_calendar.
function! calendar#save() abort
  let nr = bufnr('')
  if has_key(b:, 'calendar')
    let s:calendar[nr] = b:calendar
  endif
  if has_key(b:, '_calendar')
    let s:_calendar[nr] = b:_calendar
  endif
endfunction

" Revive b:calendar and b:_calendar.
function! calendar#revive() abort
  let nr = bufnr('')
  if !has_key(b:, 'calendar') && has_key(s:calendar, nr)
    let b:calendar = get(s:calendar, nr, {})
  endif
  if !has_key(b:, '_calendar') && has_key(s:_calendar, nr)
    let b:_calendar = get(s:_calendar, nr, {})
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
