" =============================================================================
" Filename: autoload/calendar/day/japan.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:29:01.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" TODO: In Japan, The calendar before switching to Gregorian's calendar was
" not Julian's. It was a lunisolar calendar. Therefore, the day before 1873/1/1
" was 1872/12/3, not 1872/12/19. For more infomation, see:
" http://en.wikipedia.org/wiki/Tenp%C5%8D_calendar
let s:constructor = calendar#constructor#day_hybrid#new(1873, 1, 1)

function! calendar#day#japan#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#japan#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#japan#today() abort
  return s:constructor.today()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
