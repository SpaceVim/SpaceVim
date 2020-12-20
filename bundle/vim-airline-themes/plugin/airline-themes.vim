" MIT License. Copyright (c) 2013-2020 Bailey Ling & Contributors.
" vim: et ts=2 sts=2 sw=2

let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

if &cp || v:version < 702 || (exists('g:loaded_airline_themes') && g:loaded_airline_themes)
  finish
endif
let g:loaded_airline_themes = 1

let &cpo = s:save_cpo
unlet s:save_cpo
