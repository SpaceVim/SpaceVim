" =============================================================================
" Filename: autoload/calendar/mark.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:30:36.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Mark controller.
function! calendar#mark#new() abort
  return extend(copy(s:self), { 'mark': {} })
endfunction

let s:self = {}

function! s:self.set(mark) dict abort
  let self.mark[a:mark] = copy(b:calendar.day().get_ymd()) + copy(b:calendar.time().get_hms())
  let self.mark["'"] = self.mark[a:mark]
endfunction

function! s:self.get(mark) dict abort
  let mark = a:mark ==# '`' ? "'" : a:mark
  if has_key(self.mark, mark)
    let m = self.mark[mark]
    call b:calendar.set_time(b:calendar.time().new(m[3], m[4], m[5]))
    call b:calendar.go(b:calendar.day().new(m[0], m[1], m[2]))
  else
    call calendar#echo#message(calendar#message#get('mark_not_set') . mark)
  endif
endfunction

function! s:self.showmarks() dict abort
  let marks = ['mark    year  month  day    hour minute second']
  let format = '%s     %6d   %4d %4d    %4d   %4d   %4d'
  for [k, m] in items(self.mark)
    call add(marks, printf(format, k, m[0], m[1], m[2], m[3], m[4], m[5]))
  endfor
  call add(marks, calendar#message#get('hit_any_key'))
  call calendar#echo#echo(join(marks, "\n"))
  call getchar()
endfunction

function! s:self.delmarks(...) dict abort
  if a:0
    if has_key(self.mark, a:1)
      unlet self.mark[a:1]
    endif
  else
    let self.mark = {}
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
