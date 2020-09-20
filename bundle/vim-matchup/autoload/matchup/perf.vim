" vim match-up - even better matching
"
" Maintainer: Andy Massimino
" Email:      a@normed.space
"

let s:save_cpo = &cpo
set cpo&vim

let s:time_start = {}
let s:alpha = 2.0/(10+1)

let g:matchup#perf#times = {}

function! matchup#perf#tic(context)
  let s:time_start[a:context] = reltime()
endfunction

function! matchup#perf#toc(context, state)
  let l:elapsed = s:reltimefloat(reltime(s:time_start[a:context]))

  let l:key = a:context.'#'.a:state
  if has_key(g:matchup#perf#times, l:key)
    if l:elapsed > g:matchup#perf#times[l:key].maximum
      let g:matchup#perf#times[l:key].maximum = l:elapsed
    endif
    let g:matchup#perf#times[l:key].last = l:elapsed
    let g:matchup#perf#times[l:key].emavg = s:alpha*l:elapsed
          \ + (1-s:alpha)*g:matchup#perf#times[l:key].emavg
  else
    let g:matchup#perf#times[l:key] = {
          \ 'maximum' : l:elapsed,
          \ 'emavg'   : l:elapsed,
          \ 'last'    : l:elapsed,
          \}
  endif
endfunction

function! s:sort_by_last(a, b)
  let l:a = g:matchup#perf#times[a:a].last
  let l:b = g:matchup#perf#times[a:b].last
  return l:a == l:b ? 0 : l:a > l:b ? 1 : -1
endfunction

function! matchup#perf#show_times()
  let l:keys = keys(g:matchup#perf#times)
  let l:contexts = uniq(sort(map(copy(l:keys), 'split(v:val, "#")[0]')))
  if empty(l:contexts)
    echo 'no times'
    return
  end

  echohl Title
  echo printf("%42s%11s%17s", 'average', 'last', 'maximum')
  echohl None
  for l:c in l:contexts
    echohl Special
    echo '['.l:c.']'
    echohl None
    let l:states = filter(copy(l:keys), 'v:val =~# "^\\V'.l:c.'#"')
    call sort(l:states, 's:sort_by_last')
    for l:s in l:states
      echo printf("  %-25s%12.2gms%12.2gms%12.2gms",
            \ join(split(l:s,'#')[1:],'#'),
            \ 1000*g:matchup#perf#times[l:s].emavg,
            \ 1000*g:matchup#perf#times[l:s].last,
            \ 1000*g:matchup#perf#times[l:s].maximum)
    endfor
  endfor
endfunction

command! MatchupShowTimes call matchup#perf#show_times()
command! MatchupClearTimes let g:matchup#perf#times = {}

let s:timeout = 0
let s:timeout_enabled = 0
let s:timeout_pulse_time = reltime()

function! matchup#perf#timeout() " {{{1
  return float2nr(s:timeout)
endfunction

"}}}1
function! matchup#perf#timeout_start(timeout) " {{{1
  let s:timeout = a:timeout
  let s:timeout_enabled = (a:timeout == 0) ? 0 : 1
  let s:timeout_pulse_time = reltime()
endfunction

" }}}1
function! matchup#perf#timeout_check() " {{{1
  if !s:timeout_enabled | return 0 | endif
  let l:elapsed = 1000.0 * s:reltimefloat(reltime(s:timeout_pulse_time))
  let s:timeout -= l:elapsed
  let s:timeout_pulse_time = reltime()
  return s:timeout <= 0.0
endfunction

" }}}1

" function! s:reltimefloat(time) {{{1
if exists('*reltimefloat')
  function! s:reltimefloat(time)
    return reltimefloat(a:time)
  endfunction
else
  function! s:reltimefloat(time)
    return str2float(reltimestr(a:time))
  endfunction
endif

" }}}1

let &cpo = s:save_cpo

" vim: fdm=marker sw=2

