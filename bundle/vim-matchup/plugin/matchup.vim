" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

if !get(g:, 'matchup_enabled', 1) || &cp
  finish
endif

if !get(g:, 'matchup_no_version_check', 0)
      \ && !(v:version >= 704 || has('nvim-0.1.7'))
  echoerr 'match-up does not support this version of vim'
  finish
endif

if !has('reltime')
  echoerr 'match-up requires reltime()'
  finish
endif

if exists('g:loaded_matchup')
  finish
endif
let g:loaded_matchup = 1

if exists('g:loaded_matchit') && exists(':MatchDebug')
  runtime! autoload/matchup/unmatchit.vim
endif
let g:loaded_matchit = 1

" ensure pi_paren is loaded but deactivated
try
  runtime plugin/matchparen.vim
  au! matchparen
catch /^Vim\%((\a\+)\)\=:E216/
  unlet! g:loaded_matchparen
  runtime plugin/matchparen.vim
  silent! au! matchparen
  let g:loaded_matchparen = 1
endtry
command! NoMatchParen call matchup#matchparen#toggle(0)
command! DoMatchParen call matchup#matchparen#toggle(1)

hi def link MatchParenCur MatchParen
hi def link MatchWord MatchParen
" hi def link MatchWordCur MatchParenCur
hi def link MatchBackground ColorColumn

if get(g:, 'matchup_override_vimtex', 0)
  let g:vimtex_matchparen_enabled = 0
endif

call matchup#init()

" vim: fdm=marker sw=2

