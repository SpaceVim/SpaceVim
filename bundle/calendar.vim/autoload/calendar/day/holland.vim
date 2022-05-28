" =============================================================================
" Filename: autoload/calendar/day/holland.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:28:56.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

let s:constructor = calendar#constructor#day_hybrid#new(1583, 1, 1)

function! calendar#day#holland#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#holland#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#holland#today() abort
  return s:constructor.today()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
