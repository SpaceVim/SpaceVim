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

call matchup#util#patch_match_words(
      \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>',
      \ '<\@<=\([^/][^ \t>]*\)\%(>\|$\|[ \t][^>]*\%(>\|$\)\):<\@<=/\1>'
      \)

if matchup#util#matchpref('nolists',
      \ get(g:, 'matchup_matchpref_html_nolists', 0))
  call matchup#util#patch_match_words(
        \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>',
        \ '')
  call matchup#util#patch_match_words(
        \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>',
        \ '')
endif

if matchup#util#matchpref('tagnameonly', 0)
  call matchup#util#patch_match_words(
        \ '\)\%(',
        \ '\)\g{hlend}\%(')
  call matchup#util#patch_match_words(
        \ ']l\>[',
        \ ']l\>\g{hlend}[')
  call matchup#util#patch_match_words(
        \ 'dl\>',
        \ 'dl\>\g{hlend}')
endif

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

