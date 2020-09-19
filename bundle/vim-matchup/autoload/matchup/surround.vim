" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

function! matchup#surround#delimited(is_cap, op, type) " {{{1
  call matchup#perf#timeout_start(1000)

  let [l:open, l:close] = matchup#delim#get_surrounding(
        \ a:type, v:count, { 'local': 0 })
  if empty(l:open) || empty(l:close)
    return
  endif

  if a:op ==# 'c'
    let l:char = nr2char(getchar())
    if index(["\<esc>","\<c-c>"], l:char) >= 0
      return
    endif
  endif
  let l:tpope = !empty(maparg('<plug>VSurround', 'x'))

  let [l:l1, l:c11, l:c12] = [l:open.lnum, l:open.cnum,
        \ l:open.cnum + strlen(l:open.match) - 1]
  let [l:l2, l:c21, l:c22] = [l:close.lnum, l:close.cnum,
        \ l:close.cnum + strlen(l:close.match) - 1]

  if a:op ==# 'd' || a:op ==# 'c'
    call matchup#pos#set_cursor(l1, c12+1)

    let [l:insl, l:insr] = ['', '']
    if a:op ==# 'c' && !l:tpope
      let l:idx = index(s:pairtrans, l:char)
      let l:insl = l:idx < 0 ? l:char : s:pairtrans[l:idx/2*2]
      let l:insr = l:idx < 0 ? l:char : s:pairtrans[l:idx/2*2+1]
    endif

    let l:line = getline(l:l2)
    call setline(l:l2, strpart(l:line, 0, l:c21-1)
          \ . l:insr . strpart(l:line, l:c22))
    let l:regtext = strpart(l:line, l:c21-1, l:c22-l:c21+1)

    let l:line = getline(l:l1)
    call setline(l:l1, strpart(l:line, 0, l:c11-1)
          \ . l:insl . strpart(l:line, l:c12))

    call setreg(v:register, strpart(l:line, l:c11-1, l:c12-l:c11+1)
          \ . ' ' . l:regtext)

    let l:epos = l:c21-1 - (l:l1 == l:l2
          \ ? (l:c12-l:c11+1-strlen(l:insl)-strlen(l:insr)) : 0)
    call setpos("']", [0, l:l2, l:epos, 0])
    call setpos("'[", [0, l:l1, l:c11, 0])
  endif

  if a:op ==# 'd' || a:op ==# 'c' && empty(l:char)
    silent! call repeat#set("\<plug>(matchup-ds%)", v:count)
  elseif a:op ==# 'c' && l:tpope
    normal! `[v`]
    undojoin
    execute "normal \<plug>VSurround".l:char
    silent! call repeat#set("\<plug>(matchup-cs%)"
          \ . matchstr(g:repeat_sequence, 'SSurroundRepeat\zs.\+'),
          \ v:count)
  endif

  call matchup#pos#set_cursor(l1, c11)
endfunction

let s:pairtrans = split('()<>[]{}«»“”', '\ze')

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

