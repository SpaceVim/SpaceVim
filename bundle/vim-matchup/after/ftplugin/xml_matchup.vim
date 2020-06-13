" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

if !exists('g:loaded_matchup') || !exists('b:did_ftplugin')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if matchup#util#matchpref('tagnameonly', 0)
  call matchup#util#patch_match_words('\)\%(', '\)\g{hlend}\%(')
  call matchup#util#patch_match_words('\)\%(', '\)\g{hlend}\%(')
endif

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

