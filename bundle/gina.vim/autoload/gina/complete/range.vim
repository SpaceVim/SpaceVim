
function! gina#complete#range#any(arglead, cmdline, cursorpos) abort
  return s:complete(
        \ function('gina#complete#commit#any'),
        \ a:arglead, a:cmdline, a:cursorpos,
        \)
endfunction

function! gina#complete#range#branch(arglead, cmdline, cursorpos) abort
  return s:complete(
        \ function('gina#complete#commit#branch'),
        \ a:arglead, a:cmdline, a:cursorpos,
        \)
endfunction

function! gina#complete#range#local_branch(arglead, cmdline, cursorpos) abort
  return s:complete(
        \ function('gina#complete#commit#branch'),
        \ a:arglead, a:cmdline, a:cursorpos,
        \)
endfunction

function! gina#complete#range#remote_branch(arglead, cmdline, cursorpos) abort
  return s:complete(
        \ function('gina#complete#commit#branch'),
        \ a:arglead, a:cmdline, a:cursorpos,
        \)
endfunction

function! gina#complete#range#hashref(arglead, cmdline, cursorpos) abort
  return s:complete(
        \ function('gina#complete#commit#branch'),
        \ a:arglead, a:cmdline, a:cursorpos,
        \)
endfunction


" Private --------------------------------------------------------------------
function! s:complete(fn, arglead, cmdline, cursorpos) abort
  if a:arglead =~# '^[^.]*\.\.\.\?'
    let lhs = matchstr(a:arglead, '^[^.]*\.\.\.\?')
    let rhs = matchstr(a:arglead, '^[^.]*\.\.\.\?\zs.*')
    let candidates = a:fn(rhs, a:cmdline, a:cursorpos)
    return map(candidates, 'lhs . v:val')
  else
    return a:fn(a:arglead, a:cmdline, a:cursorpos)
  endif
endfunction
