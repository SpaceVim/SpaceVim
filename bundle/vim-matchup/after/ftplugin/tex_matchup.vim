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

function! s:has_plugin(plug)
  return !empty(filter(split(&rtp,','), 'v:val =~? ''\<'.a:plug.'\>'''))
endfunction

let s:not_bslash = '\v%(\\@<!%(\\\\)*)@4<=\m'

function! s:get_match_words()
  " left and right modifiers, any delimiters
  let l:delim = '\%(\\\w\+\>\|\\[|{}]\|.\)'
  let l:match_words = '\\left\>'.l:delim
        \ .':\\middle\>'.l:delim
        \ .':\\right\>'.l:delim
  let l:match_words .= ',\(\\[bB]igg\?\)l\>'.l:delim
        \ . ':\1m\>'.l:delim
        \ . ':\1r\>'.l:delim

  " un-sided sized, left and right delimiters
  let l:mod = '\(\\[bB]igg\?\)'
  let l:wdelim = '\%(angle\|floor\|ceil\|[vV]ert\|brace\)\>'
  let l:ldelim = '\%(\\l'.l:wdelim.'\|\\[lu]lcorner\>\|(\|\[\|\\{\)'
  let l:mdelim = '\%(\\vert\>\||\|\\|\)'
  let l:rdelim = '\%(\\r'.l:wdelim.'\|\\[lu]rcorner\>\|)\|]\|\\}\)'
  let l:mtopt = '\%(\%(\w\[\)\@2<!\|\%(\\[bB]igg\?\[\)\@6<=\)'
  let l:match_words .= ','.l:mod.l:ldelim
        \ . ':\1'.l:mdelim
        \ . ':'.l:mtopt.'\1'.l:rdelim

  " unmodified delimiters
  let l:nomod = '\%(\\left\|\\right\|\[\@1<!\\[bB]igg\?[lr]\?\)\@6<!'
  for l:pair in [['\\{', '\\}'], ['\[', ']'], ['(', ')'],
        \ ['\\[lu]lcorner', '\\[lu]rcorner']]
    let l:match_words .= ','.l:nomod.s:not_bslash.l:pair[0]
          \ . ':'.l:nomod.s:not_bslash.l:pair[1]
  endfor
  let l:match_words .= ','.l:nomod.s:not_bslash.'\\l\('.l:wdelim.'\)'
        \ . ':'.l:nomod.s:not_bslash.'\\r\1\>'

  " the curly braces
  let l:match_words .= ',{:}'

  " latex equation markers
  let l:match_words .= ',\\(:\\),'.s:not_bslash.'\\\[:\\]'

  " simple blocks
  let l:match_words .= ',\\if\%(\w\|@\)*\>:\\else\>:\\fi\>'
  let l:match_words .= ',\\makeatletter:\\makeatother'
  let l:match_words .= ',\\begingroup:\\endgroup,\\bgroup:\\egroup'

  " environments
  let l:match_words .= ',\\begin{tabular}'
        \ . ':\\toprule\>:\\midrule\>:\\bottomrule\>'
        \ . ':\\end{tabular}'

  " enumerate, itemize
  let l:match_words .= ',\\begin\s*{\(enumerate\*\=\|itemize\*\=\)}'
        \ . ':\\item\>:\\end\s*{\1}'

  " generic environment
  let l:match_words .= ',\\begin\s*{\([^}]*\)}:\\end\s*{\1}'

  return l:match_words
endfunction

function! s:setup_match_words()
  setlocal matchpairs=(:),{:},[:]
  let b:matchup_delim_nomatchpairs = 1
  let b:match_words = s:get_match_words()

  " the syntax method is too slow for latex
  let b:match_skip = 'r:\\\@<!\%(\\\\\)*%'

  " the old regexp engine is a bit faster '\%#=1'
  let b:matchup_regexpengine = 1

  let b:undo_ftplugin =
        \ (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
        \ . 'unlet! b:matchup_delim_nomatchpairs b:match_words'
        \ . ' b:match_skip b:matchup_regexpengine'
endfunction

if get(g:, 'vimtex_enabled',
      \ s:has_plugin('vimtex') || exists('*vimtex#init'))
  if get(g:, 'matchup_override_vimtex', 0)
    silent! nunmap <buffer> %
    silent! xunmap <buffer> %
    silent! ounmap <buffer> %

    " lervag/vimtex/issues/1051
    let g:vimtex_matchparen_enabled = 0
    silent! call vimtex#matchparen#disable()

    call s:setup_match_words()
  else
    let b:matchup_matchparen_enabled = 0
    let b:matchup_matchparen_fallback = 0
  endif
else
  call s:setup_match_words()
endif

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

