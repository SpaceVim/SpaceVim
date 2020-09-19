" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

function! matchup#text_obj#delimited(is_inner, visual, type) " {{{1
  let l:v_motion_force = matchup#motion_force()

  " get the current selection, move to the _start_ the of range
  if a:visual
    let l:selection = getpos("'<")[1:2] + getpos("'>")[1:2]
    call matchup#pos#set_cursor(getpos("'<"))
  endif

  " motion forcing
  let l:forced = a:visual ? '' : l:v_motion_force

  " determine if operator is able to act line-wise (i.e., for inner)
  let l:linewise_op = index(g:matchup_text_obj_linewise_operators,
        \ v:operator) >= 0

  if v:operator ==# 'g@'
    let l:save_reg = v:register
    let l:spec = matchlist(g:matchup_text_obj_linewise_operators,
          \ '^g@\%(,\(.\+\)\)\?')
    if !empty(l:spec)
      if empty(l:spec[1])
        let l:linewise_op = 1
      else
        execute 'let l:linewise_op =' l:spec[1]
      endif
    endif
  elseif v:operator ==# ':'
        \ && index(g:matchup_text_obj_linewise_operators,
        \          visualmode()) >= 0
    let l:linewise_op = 1
  endif

  " set the timeout fairly high
  call matchup#perf#timeout_start(725)

  " try up to six times
  for [l:local, l:try_again] in (v:count == 1
        \ || v:count > g:matchup_delim_count_max)
        \ ? a:is_inner ? [[0, 0], [0, 1], [0, 2], [0, 3]]
        \              : [[0, 0], [0, 1], [0, 2]]
        \ : a:is_inner ? [[1, 0], [0, 0], [1, 1], [0, 1], [1, 2], [0, 2]]
        \              : [[1, 0], [0, 0], [1, 1], [0, 1]]

    let l:count = v:count1 + l:try_again

    " we use v:count1 on the first try and increment each successive time
    " find the open-close block then narrow down to local after
    let [l:open_, l:close_] = matchup#delim#get_surrounding(
          \ a:type, l:count, { 'local': 0 })

    if empty(l:open_)
      if a:visual
        normal! gv
      else
        " TODO: can this be simplified by making omaps <expr>?
        " invalid text object, try to do nothing
        " cause a drop into normal mode
        call feedkeys("\<c-\>\<c-n>\<esc>", 'n')

        " and undo the text vim enters if necessary
        call feedkeys(":call matchup#text_obj#undo("
              \ .undotree().seq_cur.")\<cr>:\<c-c>", 'n')
      endif
      return
    endif

    if l:local
      let [l:open, l:close] = matchup#delim#get_surround_nearest(l:open_)
      if empty(l:open)
        let [l:open, l:close] = [l:open_, l:open_.links.next]
      endif
    else
      let [l:open, l:close] = [l:open_, l:open_.links.close]
    endif

    " no way to specify an empty region so we need to use some tricks
    let l:epos = [l:open.lnum, l:open.cnum]
    let l:epos[1] += matchup#delim#end_offset(l:open)
    if !a:visual && a:is_inner
          \ && matchup#pos#equal(l:close, matchup#pos#next(l:epos))

      " TODO: cpo-E
      if v:operator ==# 'c'
        " this is apparently the most reliable way to handle
        " the 'c' operator, although it raises a TextChangedI
        " and fills registers with a space (from targets.vim)
        call matchup#pos#set_cursor(l:close)
        silent! execute "normal! i \<esc>v"
      elseif stridx('<>', v:operator) < 0
        let l:byte = line2byte(l:close.lnum) + l:close.cnum - 1
        call feedkeys(l:byte.'go', 'n')
      endif

      return
    endif

    let [l:l1, l:c1, l:l2, l:c2] = [l:open.lnum,  l:open.cnum,
          \ l:close.lnum, l:close.cnum]

    " whether the pair has at least one line in between them
    let l:line_count = l:l2 - l:l1 + 1

    " special case: if inner and the current selection coincides
    " with the open and close positions, try for a second time
    " this allows vi% in [[   ]] to work
    if a:visual && a:is_inner && l:selection == [l:l1, l:c1, l:l2, l:c2]
      continue
    endif

    " adjust the borders of the selection
    if a:is_inner
      let l:c1 += matchup#delim#end_offset(l:open)
      let [l:l1, l:c1] = matchup#pos#next(l:l1, l:c1)[1:2]
      let l:sol = (l:c2 <= 1)
      let [l:l2, l:c2] = matchup#pos#prev(l:l2, l:c2)[1:2]

      " don't select only indent at close
      while matchup#util#in_indent(l:l2, l:c2)
        let l:c2 = 1
        let [l:l2, l:c2] = matchup#pos#prev(l:l2, l:c2)[1:2]
        let l:sol = 1
      endwhile

      " include the line break if we had wrapped around
      if a:visual && l:sol
        let l:c2 = strlen(getline(l:l2))+1
      endif

      if !a:visual
        " otherwise adjust end pos
        if l:sol
          let [l:l2, l:c2] = matchup#pos#next(l:l2, l:c2)[1:2]
        endif

        " toggle exclusive: difference between di% and dvi%
        let l:inclusive = 0
        if !l:sol && matchup#pos#smaller_or_equal(
              \ [l:l1, l:c1], [l:l2, l:c2])
          let l:inclusive = 1
        endif
        if l:forced ==# 'v'
          let l:inclusive = !l:inclusive
        endif

        " sometimes operate in visual line motion (re-purpose force)
        " cf src/normal.c:1824
        if empty(l:v_motion_force)
              \ && l:c2 <= 1 && l:line_count > 1 && !l:inclusive
          let l:l2 -= 1
          if l:c1 <= 1 || matchup#util#in_indent(l:l1, l:c1-1)
            let l:forced = 'V'
            let l:inclusive = 1
          else
            " end_adjusted
            let l:c2 = strlen(getline(l:l2)) + 1
            if l:c2 > 1
              let l:c2 -= 1
              let l:inclusive = 1
            endif
          endif
        endif

        if !l:inclusive
          let [l:l2, l:c2] = matchup#pos#prev(l:l2, l:c2)[1:2]
        endif
      endif

      " check for the line-wise special case
      if l:line_count > 2 && l:linewise_op && strlen(l:close.match) > 1
        if l:c1 != 1
          let l:l1 += 1
          let l:c1 = 1
        endif
        let l:l2 = l:close.lnum - 1
        let l:c2 = strlen(getline(l:l2))+1
      endif

      " if this would be an empty selection..
      if !a:visual && (l:l2 < l:l1 || l:l1 == l:l2 && l:c1 > l:c2)
        if v:operator ==# 'c'
          call matchup#pos#set_cursor(l:l1, l:c1)
          silent! execute "normal! i \<esc>v"
        elseif stridx('<>', v:operator) < 0
          let l:byte = line2byte(l:l1) + l:c1 - 1
          call feedkeys(l:byte.'go', 'n')
        endif
        return
      endif
    else
      let l:c2 += matchup#delim#end_offset(l:close)

      " special case for delete operator
      if !a:visual && v:operator ==# 'd'
            \ && strpart(getline(l:l2), l:c2) =~# '^\s*$'
            \ && strpart(getline(l:l2), 0, l:c1-1) =~# '^\s*$'
        let l:c1 = 1
        let l:c2 = strlen(getline(l:l2))+1
      endif
    endif

    " in visual line mode, force new selection to not be smaller
    " (only check line numbers)
    if a:visual && visualmode() ==# 'V'
          \ && (l:l1 > l:selection[0] || l:l2 < l:selection[2])
      continue
    endif

    " in other visual modes, try again if we didn't reach a bigger range
    if a:visual && visualmode() !=# 'V'
          \ && !matchup#pos#equal(l:selection[0:1], l:selection[2:3])
          \ && (l:selection == [l:l1, l:c1, l:l2, l:c2]
          \ || matchup#pos#larger([l:l1, l:c1], l:selection[0:1])
          \ || matchup#pos#larger(l:selection[2:3], [l:l2, l:c2]))
      continue
    endif

    break
  endfor

  " set the proper visual mode for this selection
  let l:select_mode = (v:operator ==# ':')
        \ ? visualmode()
        \ : (l:forced !=# '')
        \   ? l:forced
        \   : 'v'

  if &selection ==# 'exclusive'
    let [l:l2, l:c2] = matchup#pos#next_eol(l:l2, l:c2)[1:2]
  endif

  " apply selection
  execute 'normal!' l:select_mode
  normal! o
  call matchup#pos#set_cursor(l:l1, l:c1)
  normal! o
  call matchup#pos#set_cursor(l:l2, l:c2)
  if exists('l:save_reg')
    execute 'normal! "' . l:save_reg
  endif
endfunction

function! matchup#text_obj#undo(seq)
  if undotree().seq_cur > a:seq
    silent! undo
  endif
endfunction

" }}}1
function! matchup#text_obj#double_click() " {{{1
  let [l:open, l:close] = [{}, {}]

  call matchup#perf#timeout_start(0)
  let l:delim = matchup#delim#get_current('all', 'both_all')
  if !empty(l:delim)
    let l:matches = matchup#delim#get_matching(l:delim, 1)
    if len(l:matches) > 1 && has_key(l:delim, 'links')
      let [l:open, l:close] = [l:delim.links.open, l:delim.links.close]
    endif
  endif

  if empty(l:open) || empty(l:close)
    call feedkeys("\<2-LeftMouse>", 'nt')
    return
  endif

  let [l:lnum, l:cnum] = [l:close.lnum, l:close.cnum]
  let l:cnum += matchup#delim#end_offset(l:close)

  if &selection ==# 'exclusive'
    let [l:lnum, l:cnum] = matchup#pos#next_eol(l:lnum, l:cnum)[1:2]
  endif

  call matchup#pos#set_cursor(l:open)
  normal! v
  call matchup#pos#set_cursor(l:lnum, l:cnum)
  if l:delim.side ==# 'close'
    normal! o
  endif
endfunction

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

