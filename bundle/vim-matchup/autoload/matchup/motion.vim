" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

" TODO this can probably be simplified
function! matchup#motion#op(motion) abort
  call matchup#motion_force()
  let l:sid = matchup#motion_sid()
  let s:v_operator = v:operator
  execute 'normal' l:sid.'(wise)' . (v:count > 0 ? v:count : '')
        \ . l:sid.'(matchup-'.a:motion.')'
  unlet s:v_operator
endfunction

function matchup#motion#getoper()
  return get(s:, 'v_operator', '')
endfunction

function! matchup#motion#find_matching_pair(visual, down) " {{{1
  let [l:count, l:count1] = [v:count, v:count1]

  let l:is_oper = !empty(get(s:, 'v_operator', ''))

  if a:visual && !l:is_oper
    normal! gv
  endif

  if a:down && l:count > g:matchup_motion_override_Npercent
    " TODO: dv50% does not work properly
    if a:visual && l:is_oper
      normal! V
    endif
    exe 'normal!' l:count.'%'
    return
  endif

  " disable the timeout
  call matchup#perf#timeout_start(0)

  " get a delim where the cursor is
  let l:delim = matchup#delim#get_current('all', 'both_all')
  if empty(l:delim)
    " otherwise search forward
    let l:delim = matchup#delim#get_next('all', 'both_all')
    if empty(l:delim) | return | endif
  endif

  " loop count number of times
  for l:dummy in range(l:count1)
    let l:matches = matchup#delim#get_matching(l:delim, 1)
    if len(l:matches) <= (l:delim.side ==# 'mid' ? 2 : 1) | return | endif
    if !has_key(l:delim, 'links') | return | endif
    let l:delim = get(l:delim.links, a:down ? 'next' : 'prev', {})
    if empty(l:delim) | return | endif
  endfor

  if a:visual && l:is_oper
    normal! gv
  endif

  let l:exclusive = l:is_oper && (g:v_motion_force ==# 'v')
  let l:forward = ((a:down && l:delim.side !=# 'open')
        \ || l:delim.side ==# 'close')

  " go to the end of the delimiter, if necessary
  let l:column = l:delim.cnum
  if g:matchup_motion_cursor_end && !l:is_oper && l:forward
    let l:column = matchup#delim#jump_target(l:delim)
  endif

  let l:start_pos = matchup#pos#get_cursor()

  normal! m`

  " column position of last character in match
  let l:eom = l:delim.cnum + matchup#delim#end_offset(l:delim)

  if l:is_oper && l:forward
    let l:column = l:exclusive ? (l:column - 1) : l:eom
  endif

  if l:is_oper && l:exclusive
        \ && matchup#pos#smaller(l:delim, l:start_pos)
    normal! o
    call matchup#pos#set_cursor(matchup#pos#prev(l:start_pos))
    normal! o
  endif

  " special handling for d%
  let [l:start_lnum, l:start_cnum] = l:start_pos[1:2]
  if get(s:, 'v_operator', '') ==# 'd' && l:start_lnum != l:delim.lnum
        \ && g:v_motion_force ==# ''
    let l:tl = [l:start_lnum, l:start_cnum]
    let [l:tl, l:br, l:swap] = l:tl[0] <= l:delim.lnum
          \ ? [l:tl, [l:delim.lnum, l:eom], 0]
          \ : [[l:delim.lnum, l:delim.cnum], l:tl, 1]

    if getline(l:tl[0]) =~# '^[ \t]*\%'.l:tl[1].'c'
          \ && getline(l:br[0]) =~# '\%'.(l:br[1]+1).'c[ \t]*$'
      if l:swap
        normal! o
        call matchup#pos#set_cursor(l:br[0], strlen(getline(l:br[0]))+1)
        normal! o
        let l:column = 1
      else
        normal! o
        call matchup#pos#set_cursor(l:tl[0], 1)
        normal! o
        let l:column = strlen(getline(l:br[0]))+1
      endif
    endif
  endif

  let l:lnum = l:delim.lnum

  " make adjustments for selection option 'exclusive
  if l:forward && a:visual && &selection ==# 'exclusive'
    let [l:lnum, l:column] = matchup#pos#next_eol(l:lnum, l:column)[1:2]
  endif
  if !l:forward && l:is_oper && &selection ==# 'exclusive'
    normal! o
    call matchup#pos#set_cursor(matchup#pos#next_eol(
          \ matchup#pos#get_cursor()))
    normal! o
  endif

  call matchup#pos#set_cursor(l:lnum, l:column)
  if stridx(&foldopen, 'percent') >= 0
    normal! zv
  endif
endfunction

" }}}1
function! matchup#motion#find_unmatched(visual, down, ...) " {{{1
  call matchup#perf#tic('motion#find_unmatched')

  let l:opts = a:0 ? a:1 : {}
  let l:count = v:count1

  let l:is_oper = !empty(get(s:, 'v_operator', ''))
  let l:exclusive = l:is_oper
        \ && g:v_motion_force !=# 'v' && g:v_motion_force !=# "\<c-v>"

  if a:visual
    normal! gv
  endif

  " set the timeout fairly high by default
  let l:timeout = get(l:opts, 'timeout', 750)
  call matchup#perf#timeout_start(l:timeout)

  for l:tries in range(3)
    let [l:open, l:close] = matchup#delim#get_surrounding('delim_all',
          \ l:tries ? l:count : 1,
          \ { 'check_skip': get(l:opts, '__where_impl__', 0) })

    if empty(l:open) || empty(l:close)
      call matchup#perf#toc('motion#find_unmatched', 'fail'.l:tries)
      return
    endif

    let l:delim = a:down ? l:close : l:open

    let l:save_pos = matchup#pos#get_cursor()
    let l:new_pos = [l:delim.lnum, l:delim.cnum]

    " this is an exclusive motion, ]%
    if l:delim.side ==# 'close'
      if l:exclusive
        let l:new_pos[1] -= 1
      else
        let l:new_pos[1] += matchup#delim#end_offset(l:delim)
      endif
    endif

    " if the cursor didn't move, increment count
    if matchup#pos#equal(l:save_pos, l:new_pos)
      let l:count += 1
    elseif l:tries
      break
    endif

    if l:count <= 1
      break
    endif
  endfor

  if a:down && !l:is_oper
    let l:new_pos[1] = matchup#delim#jump_target(l:delim)
  endif

  " this is an exclusive motion, [%
  if !a:down && l:exclusive
    normal! o
    call matchup#pos#set_cursor(matchup#pos#prev(
          \ matchup#pos#get_cursor()))
    normal! o
  endif

  " handle selection option 'exclusive' going backwards
  if !a:down && l:is_oper && &selection ==# 'exclusive'
    normal! o
    call matchup#pos#set_cursor(matchup#pos#next_eol(
          \ matchup#pos#get_cursor()))
    normal! o
  endif

  " handle selection option 'exclusive' going forwards
  if a:down && l:is_oper && &selection ==# 'exclusive'
    let l:new_pos = matchup#pos#next_eol(l:new_pos)[1:2]
  endif

  if get(l:opts, '__where_impl__', 0)
    let l:opts.delim = l:delim
  else
    normal! m`
  endif
  call matchup#pos#set_cursor(l:new_pos)

  call matchup#perf#toc('motion#find_unmatched', 'done')
endfunction

" }}}1
function! matchup#motion#jump_inside(visual) " {{{1
  let l:count = v:count1

  let l:save_pos = matchup#pos#get_cursor()

  call matchup#perf#timeout_start(750)

  if a:visual
    normal! gv
  endif

  for l:counter in range(l:count)
    if l:counter
      let l:delim = matchup#delim#get_next('all', 'open')
    else
      let l:delim = matchup#delim#get_current('all', 'open')
      if empty(l:delim)
        let l:delim = matchup#delim#get_next('all', 'open')
      endif
    endif
    if empty(l:delim)
      call matchup#pos#set_cursor(l:save_pos)
      return
    endif

    let l:new_pos = [l:delim.lnum, l:delim.cnum]
    let l:new_pos[1] += matchup#delim#end_offset(l:delim)
    call matchup#pos#set_cursor(matchup#pos#next(l:new_pos))
  endfor

  call matchup#pos#set_cursor(l:save_pos)

  " convert to [~, lnum, cnum, ~] format
  let l:new_pos = matchup#pos#next(l:new_pos)

  " this is an exclusive motion except when dealing with whitespace
  let l:is_oper = !empty(get(s:, 'v_operator', ''))
  if l:is_oper
        \ && g:v_motion_force !=# 'v' && g:v_motion_force !=# "\<c-v>"
    while matchup#util#in_whitespace(l:new_pos[1], l:new_pos[2])
      let l:new_pos = matchup#pos#next(l:new_pos)
    endwhile
    let l:new_pos = matchup#pos#prev(l:new_pos)
  endif

  " jump ahead if inside indent
  if !l:is_oper && matchup#util#in_indent(l:new_pos[1], l:new_pos[2])
    let l:new_pos[2] = 1 + strlen(matchstr(
          \ getline(l:new_pos[1]), '^\s\+'))
  endif

  " handle selection option 'exclusive' (motion only goes forwards)
  if a:visual && &selection ==# 'exclusive'
    let l:new_pos = matchup#pos#next_eol(l:new_pos)
  endif

  normal! m`
  call matchup#pos#set_cursor(l:new_pos)
endfunction

" }}}1
function! matchup#motion#insert_mode() " {{{1
  call matchup#perf#timeout_start(0) " disable the timeout

  let l:delim = matchup#delim#get_current(
        \ 'all', 'both_all', {'insertmode': 1})
  if empty(l:delim) | return | endif

  let l:matches = matchup#delim#get_matching(l:delim, 1)
  if len(l:matches) <= (l:delim.side ==# 'mid' ? 2 : 1) | return | endif
  if !has_key(l:delim, 'links') | return | endif
  let l:delim = get(l:delim.links, 'next', {})
  if empty(l:delim) | return | endif

  let l:new_pos = [l:delim.lnum, l:delim.cnum]
  let l:new_pos[1] += matchup#delim#end_offset(l:delim)
  call matchup#pos#set_cursor(matchup#pos#next_eol(l:new_pos))
endfunction

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

