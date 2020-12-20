" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

if !exists('g:loaded_matchup') || !exists('b:did_ftplugin')
  finish
endif

let b:matchup_matchparen_timeout=100
let b:undo_ftplugin .= ' | unlet! b:matchup_matchparen_timeout'

" vim: fdm=marker sw=2

