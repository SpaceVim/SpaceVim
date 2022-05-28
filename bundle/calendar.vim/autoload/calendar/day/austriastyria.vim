" =============================================================================
" Filename: autoload/calendar/day/austriastyria.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/03/29 06:28:34.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Carinthia and Styria
let s:constructor = calendar#constructor#day_hybrid#new(1583, 12, 25)

function! calendar#day#austriastyria#new(y, m, d) abort
  return s:constructor.new(a:y, a:m, a:d)
endfunction

function! calendar#day#austriastyria#new_mjd(mjd) abort
  return s:constructor.new_mjd(a:mjd)
endfunction

function! calendar#day#austriastyria#today() abort
  return s:constructor.today()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
