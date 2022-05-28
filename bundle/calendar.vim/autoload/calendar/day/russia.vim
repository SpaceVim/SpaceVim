" =============================================================================
" Filename: autoload/calendar/day/russia.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:29:11.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:constructor = calendar#constructor#day_hybrid#new(1918, 2, 14)

function! calendar#day#russia#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#russia#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#russia#today() abort
  return s:constructor.today()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
