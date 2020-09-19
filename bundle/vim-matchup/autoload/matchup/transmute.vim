" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! matchup#transmute#init_module() " {{{1
  if !g:matchup_transmute_enabled | return | endif

  call matchup#transmute#enable()
endfunction

" }}}1

function! matchup#transmute#enable() " {{{1
  " TODO: add insert mode map
  " TODO: add g:matchup_transmute_auto
endfunction

" }}}1
function! matchup#transmute#disable() " {{{1

endfunction

" }}}1

function! matchup#transmute#tick(insertmode) " {{{1
  if !g:matchup_transmute_enabled | return 0 | endif

  if a:insertmode
    return 0
  endif

  if changenr() > get(w:, 'matchup_transmute_last_changenr', -1)
        \ && !empty('w:matchup_matchparen_context.prior')
    let w:matchup_transmute_last_changenr = changenr()

    return matchup#transmute#dochange(
          \ w:matchup_matchparen_context.prior.corrlist,
          \ w:matchup_matchparen_context.prior.current,
          \ w:matchup_matchparen_context.normal.current)
  endif

  return 0
endfunction

" }}}1
function! matchup#transmute#reset() " {{{1
  if !g:matchup_transmute_enabled | return 0 | endif
  let w:matchup_transmute_last_changenr = changenr()
endfunction

" }}}1
function! matchup#transmute#dochange(list, pri, cur) " {{{1
  if empty(a:list) || empty(a:pri) || empty(a:cur) | return 0 | endif

  let l:cur = a:cur

  " check back one
  if a:pri.class[0] != l:cur.class[0]
    let l:cur = matchup#delim#get_current('all', a:pri.side,
          \ {'insertmode': 1})
    if empty(l:cur) | return 0 | endif
  endif

  " right now, only same-class changes are supported
  if a:pri.class[0] != l:cur.class[0]
    return 0
  endif
  if a:pri.side =~# '^open\|close$' && a:pri.side isnot l:cur.side
    return 0
  endif
  if !matchup#pos#equal(a:pri, l:cur)
    return 0
  endif

  let l:num_changes = 0

  let l:delta = strdisplaywidth(l:cur.match)
        \ - strdisplaywidth(a:pri.match)

  for l:i in range(len(a:list))
    if l:i == a:pri.match_index | continue | endif

    let l:corr = a:list[l:i]
    let l:line = getline(l:corr.lnum)

    let l:column = l:corr.cnum
    if l:corr.lnum == l:cur.lnum && l:i > a:pri.match_index
      let l:column += l:delta
    endif

    let l:re_anchored = '\%'.(l:column).'c'
          \ . '\%('.(l:corr.regexone[l:corr.side]).'\)'

    let l:groups = copy(l:corr.groups)
    for l:grp in keys(l:groups)
      let l:count = len(split(l:re_anchored,
        \ g:matchup#re#not_bslash.'\\'.l:grp))-1
      if l:count == 0 | continue | endif

      if l:cur.groups[l:grp] ==# l:groups[l:grp]
        continue
      endif

      for l:dummy in range(len(l:count))
        " create a pattern which isolates the old group text
        let l:prevtext = s:qescape(l:groups[l:grp])
        let l:pattern = substitute(l:re_anchored,
              \ g:matchup#re#not_bslash.'\\'.l:grp,
              \ '\=''\zs\V'.l:prevtext.'\m\ze''', '')
        let l:pattern = matchup#delim#fill_backrefs(l:pattern,
              \ l:groups, 0)
        let l:string = l:cur.groups[l:grp]
        let l:line = substitute(l:line, l:pattern,
              \ '\='''.s:qescape(l:string)."'", '')
      endfor

      let l:groups[l:grp] = l:cur.groups[l:grp]
    endfor

    if getline(l:corr.lnum) !=# l:line
      if g:matchup_transmute_breakundo && l:num_changes == 0
        execute "normal! a\<c-g>u"
      endif
      call setline(l:corr.lnum, l:line)
      let l:num_changes += 1
    endif
  endfor

  return l:num_changes
endfunction

function s:qescape(str)
  return escape(substitute(a:str, "'", "''", 'g'), '\')
endfunction

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

