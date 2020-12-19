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

let b:match_skip = 's:comment\|string\|vimSynReg'
      \ . '\|vimSet\|vimFuncName\|vimNotPatSep'
      \ . '\|vimVar\|vimFuncVar\|vimFBVar\|vimOperParen'
      \ . '\|vimUserFunc'

call matchup#util#patch_match_words(
      \ '\<aug\%[roup]\s\+\%(END\>\)\@!\S:',
      \ '\<aug\%[roup]\ze\s\+\%(END\>\)\@!\S:'
      \)

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

