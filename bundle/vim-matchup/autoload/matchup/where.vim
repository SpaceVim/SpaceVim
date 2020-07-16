" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

scriptencoding utf8

let s:save_cpo = &cpo
set cpo&vim

let s:curpos = []

function! matchup#where#get(timeout) abort " {{{1
  let l:save_view = winsaveview()
  let l:trail = []

  let l:prev = [matchup#pos#get_cursor_line(), 1]
  call matchup#pos#set_cursor(l:prev)
  for l:dummy in range(15)
    " TODO make this into an api
    " TODO replace with a faster version with searchpairpos/return value?
    let l:opts_io = {
          \ '__where_impl__': 1,
          \ 'timeout': a:timeout,
          \}
    call matchup#motion#find_unmatched(0, 0, l:opts_io)

    if matchup#pos#get_cursor()[1:2] == l:prev
      break
    endif

    let l:prev = matchup#pos#get_cursor()[1:2]
    call add(l:trail, l:prev + [l:opts_io.delim])
  endfor

  call winrestview(l:save_view)
  return reverse(l:trail)
endfunction

" }}}1

function! s:print_verbose() " {{{1
  echohl Title | echon 'match-up:' | echohl None
  echon ' loading...'
  let l:trail = matchup#where#get(500)
  redraw!
  if empty(l:trail)
    echohl Title | echon 'match-up:' | echohl None
    echon ' no context found'
    return
  endif
  let l:last = -1
  for l:t in l:trail
    let l:opts = {
          \ 'noshowdir': 1,
          \ 'width': &columns - 1,
          \}
    let [l:str, l:adj] = matchup#matchparen#status_str(l:t[2], l:opts)
    if l:adj == l:last
      continue
    endif
    if l:last != -1
      echon "\n"
    endif
    call s:EchoHLString(l:str)
    let l:last = l:adj
  endfor
endfunction

" }}}1
function! s:print_short() " {{{1
  echohl Title | echon 'match-up:' | echohl None
  echon ' loading...'
  let l:trail = matchup#where#get(200)
  redraw!
  if empty(l:trail)
    echohl Title | echon 'match-up:' | echohl None
    echon ' no context found'
    return
  endif
  " TODO len(trail) is not quite right here
  let l:width = (&columns - 3*(len(l:trail)-1)) / len(l:trail)
  let l:fullstr = ''
  let l:prev = -1
  for l:t in l:trail
    let l:opts = {
          \ 'noshowdir': 1,
          \ 'compact': l:prev != -1,
          \ 'width': l:width,
          \}
    let [l:str, l:adj] = matchup#matchparen#status_str(l:t[2], l:opts)
    if l:adj == l:prev
      continue
    endif
    if l:prev != -1
      let l:fullstr .= ' %#Title#' . s:arrow() . '%#Normal# '
    endif
    let l:fullstr .= l:str
    let l:prev = l:adj
  endfor
  call matchup#perf#tic('where')
  call s:EchoHLString(l:fullstr)
  call matchup#perf#toc('where', 'echohlstring')
endfunction

function! s:arrow()
  if empty(g:matchup_where_separator)
    return '▶'
  endif
  return g:matchup_where_separator
endfunction

" }}}1

function! matchup#where#print(args)
  let l:verbose = 0
  if a:args =~ '!' || len(a:args) >= 2
        \ || a:args =~ '?' && s:curpos == getcurpos()
    let l:verbose = 1
  endif
  let s:curpos = getcurpos()

  if l:verbose
    call s:print_verbose()
  else
    call s:print_short()
  endif
endfunction

function! s:EchoHLString(str)
  let l:str = '%<' . substitute(a:str, '%{[^}]\+}', '', 'g')
  let l:pat = '\%(%\(<\)\|%#\(\w*\)#\)'
  let l:components = split(l:str, l:pat.'\&')
  call map(l:components, 'matchlist(v:val, "^".l:pat."\\(.*\\)")')

  for l:c in l:components
    let l:m = matchlist(l:c, '^'.l:pat.'\(.*\)')
    if empty(l:m)
      let l:str = l:c
    elseif !empty(l:m[1])
      let l:str = l:m[3]
      echon l:m[2]
    elseif !empty(l:m[2])
      let l:str = l:m[3]
      execute 'echohl' l:m[2]
    endif
    echon l:str
  endfor
  echohl NONE
endfunction

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

