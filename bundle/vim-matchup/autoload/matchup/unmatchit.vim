" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

" this file is loaded only from plugin/matchup.vim

if !exists('g:loaded_matchup')
      \ || !exists('g:loaded_matchit')
      \ || !exists(":MatchDebug")
  finish
endif

unlet g:loaded_matchit

delcommand MatchDebug

silent! unmap %
silent! unmap [%
silent! unmap ]%
silent! unmap a%
silent! unmap g%

" vim: fdm=marker sw=2

