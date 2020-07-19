" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! matchup#pos#set_cursor(...) " {{{1
  call cursor(s:parse_args(a:000))
endfunction

" }}}1
" function! matchup#pos#get_cursor() {{{1
if exists('*getcurpos')
  function! matchup#pos#get_cursor()
    return getcurpos()
  endfunction
else
  function! matchup#pos#get_cursor()
    return getpos('.')
  endfunction
endif

" }}}1

" }}}1
function! matchup#pos#get_cursor_line() " {{{1
  let l:pos = matchup#pos#get_cursor()
  return l:pos[1]
endfunction

" }}}1

function! matchup#pos#(...) abort " {{{1
  let [l:lnum, l:cnum; l:rest] = s:parse_args(a:000)
  return [l:lnum, l:cnum]
endfunction

" }}}1
function! matchup#pos#val(...) " {{{1
  let [l:lnum, l:cnum; l:rest] = s:parse_args(a:000)

  return 100000*l:lnum + min([l:cnum, 90000])
endfunction

" }}}1
function! matchup#pos#next_eol(...) " {{{1
  let [l:lnum, l:cnum; l:rest] = s:parse_args(a:000)

  if l:cnum > strlen(getline(l:lnum))
    return [0, l:lnum+1, 1, 0]
  endif

  let l:next = matchup#pos#next(l:lnum, l:cnum)
  if l:next[1] > l:lnum
    return [0, l:lnum, l:cnum+1, 0]
  endif
  return l:next
endfunction

" }}}1
function! matchup#pos#next(...) " {{{1
  let [l:lnum, l:cnum; l:rest] = s:parse_args(a:000)

  let l:line = getline(l:lnum)
  let l:charlen = matchend(l:line[l:cnum-1:], '.')
  if l:charlen >= 0 && l:cnum + l:charlen <= strlen(l:line)
    return [0, l:lnum, l:cnum + l:charlen, 0]
  else
    return [0, l:lnum+1, 1, 0]
  endif
endfunction

" }}}1
function! matchup#pos#prev(...) " {{{1
  let [l:lnum, l:cnum; l:rest] = s:parse_args(a:000)

  if l:cnum > 1
    return [0, l:lnum, match(getline(l:lnum)[0:l:cnum-2], '.$') + 1, 0]
  else
    return [0, max([l:lnum-1, 1]),
          \ max([strlen(getline(l:lnum-1)), 1]), 0]
  endif
endfunction

" }}}1
function! matchup#pos#larger(pos1, pos2) " {{{1
  return matchup#pos#val(a:pos1) > matchup#pos#val(a:pos2)
endfunction

" }}}1
function! matchup#pos#equal(p1, p2) " {{{1
  let l:pos1 = s:parse_args(a:p1)
  let l:pos2 = s:parse_args(a:p2)
  return l:pos1[:1] == l:pos2[:1]
endfunction

" }}}1
function! matchup#pos#smaller(pos1, pos2) " {{{1
  return matchup#pos#val(a:pos1) < matchup#pos#val(a:pos2)
endfunction

" }}}1
function! matchup#pos#smaller_or_equal(pos1, pos2) " {{{1
  return matchup#pos#smaller(a:pos1, a:pos2)
        \ || matchup#pos#equal(a:pos1, a:pos2)
endfunction

" }}}1
function! s:parse_args(args) " {{{1
  "
  " The arguments should be in one of the following forms (when unpacked):
  "
  "   [lnum, cnum]
  "   [bufnum, lnum, cnum, ...]
  "   {'lnum' : lnum, 'cnum' : cnum}
  "

  if len(a:args) > 1
    return s:parse_args([a:args])
  elseif len(a:args) == 1
    if type(a:args[0]) == type({})
      return [get(a:args[0], 'lnum'), get(a:args[0], 'cnum')]
    else
      if len(a:args[0]) == 2
        return a:args[0]
      else
        return a:args[0][1:]
      endif
    endif
  else
    return a:args
  endif
endfunction

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

