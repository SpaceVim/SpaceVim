" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

""
" example motion as described in issues/49:
"   - if on a delim, go to {count} next matching delim, up or down
"   - if not on a delim, go to {count} local surrounding, up or down
"
" {info}  dict with the following fields:
"   visual      : 1 if visual or operator mode
"   count/count1: v:count/v:count1 for this map
"   operator    : if non-empty, the operator in op mode
"   motion_force: forced operator mode, e.g, for 'dvx' this is 'v'
" {opts}  user data dict from motion definition
function! matchup#custom#example_motion(info, opts) abort
  let l:delim = matchup#delim#get_current('all', 'both_all')
  if !empty(l:delim)
    let l:matches = matchup#delim#get_matching(l:delim, 1)
    if len(l:matches)
      for _ in range(a:info.count1)
        let l:delim = l:delim.links[a:opts.down ? 'next': 'prev']
      endfor
      return matchup#custom#suggest_pos(l:delim, a:opts)
    endif
  endif

  let [l:open_, l:close_] = matchup#delim#get_surrounding(
        \ 'delim_all', v:count1)
  if empty(l:open_) || empty(l:close_)
    return []
  endif
  let [l:open, l:close] = matchup#delim#get_surround_nearest(l:open_)
  if empty(l:open)
    let [l:open, l:close] = [l:open_, l:open_.links.next]
  endif
  let l:delim = a:opts.down ? l:close : l:open

  " exclude delim in operators unless v is given
  if !empty(a:info.operator) && a:info.motion_force !=# 'v'
    if a:opts.down
      return matchup#pos#prev(l:delim)
    else
      return matchup#pos#next(matchup#delim#end_pos(l:delim))
    endif
  else
    return matchup#custom#suggest_pos(l:delim, a:opts)
  endif
endfunction

""
" api function: get the preferred cursor location for delim
" {delim}   delimiter object
" {opts}    field 'down' denotes motion direction
function! matchup#custom#suggest_pos(delim, opts) abort
  if g:matchup_motion_cursor_end && (a:delim.side ==# 'close'
        \ || a:delim.side ==# 'mid' && get(a:opts, 'down', 0))
    return [a:delim.lnum, matchup#delim#jump_target(a:delim)]
  endif
  return matchup#pos#(a:delim)
endfunction

""
" define a custom motion
" {modes} specify which modes modes of {n,o,x} the mapping is active in
" {keys}  key sequence for map
" {fcn}   function to call, must take two arguments
" [@opts] user data dict passed to function
function! matchup#custom#define_motion(modes, keys, fcn, ...) abort
  if a:modes !~# '^[nox]\+$'
    echoerr "invalid modes"
  endif

  let s:custom_counter += 1
  let l:k = s:custom_counter
  let l:opts = a:0 ? deepcopy(a:1) : {}
  call extend(l:opts, { 'fcn': a:fcn, 'keys': a:keys })
  let s:custom_opts[l:k] = l:opts

  if a:modes =~# 'n'
    execute 'nnoremap <silent> <plug>(matchup-custom-'.a:keys.')'
          \ ':<c-u>call matchup#custom#wrap(0, '.l:k.')<cr>'
    execute 'nmap' a:keys '<plug>(matchup-custom-'.a:keys.')'
  endif

  if a:modes =~# '[xo]'
    let l:sid = substitute(matchup#motion_sid(), "\<snr>", '<snr>', '')
    execute 'xnoremap <silent>' l:sid.'(matchup-custom-'.l:k.')'
          \ ':<c-u>call matchup#custom#wrap(1, '.l:k.')<cr>'
  endif

  if a:modes =~# 'x'
    execute 'xmap <silent> <plug>(matchup-custom-'.a:keys.')'
          \ l:sid.'(matchup-custom-'.l:k.')'
    execute 'xmap <silent>' a:keys '<plug>(matchup-custom-'.a:keys.')'
  endif

  if a:modes =~# 'o'
    execute 'onoremap <silent> <plug>(matchup-custom-'.a:keys.')'
          \ ':<c-u>call matchup#motion#op('
          \ . string('custom-'.l:k).')<cr>'
    if !call(matchup#motion_sid().'make_oldstyle_omaps',
          \ [a:keys, 'custom-'.a:keys])
      execute 'omap' a:keys '<plug>(matchup-custom-'.a:keys.')'
    endif
  endif
endfunction

if !exists('s:custom_opts')
  let s:custom_opts = {}
  let s:custom_counter = 0
endif

" motion wrapper
function! matchup#custom#wrap(visual, id) abort
  " default to 1 second (can override in custom motion)
  call matchup#perf#timeout_start(1000)

  let l:info = {
        \ 'visual': a:visual,
        \ 'count': v:count,
        \ 'count1': v:count1,
        \ 'operator': matchup#motion#getoper(),
        \ 'motion_force': g:v_motion_force,
        \}
  let l:is_oper = !empty(l:info.operator)
  let l:opts = s:custom_opts[a:id]

  if a:visual
    normal! gv
  endif

  let l:ret = call(l:opts.fcn, [l:info, l:opts])

  if type(l:ret) != type([]) || empty(l:ret)
    if !a:visual || l:is_oper
      execute "normal! \<esc>"
    endif
  elseif type(l:ret) == type([]) && len(l:ret) >= 2
    call matchup#pos#set_cursor(l:ret)
  endif
endfunction

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

