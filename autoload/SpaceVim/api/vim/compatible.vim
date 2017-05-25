function! SpaceVim#api#vim#compatible#get() abort
  return map({
        \ 'execute' : '',
        \ 'system' : '',
        \ 'systemlist' : '',
        \ 'globpath' : '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction


if exists('*execute')
  function! s:execute(cmd, ...) abort
    return call('execute', [a:cmd] + a:000)
  endfunction
else
  function! s:execute(cmd, ...) abort
    if a:0 == 0
      let s = 'silent'
    else
      let s = a:1
    endif
    redir => output
    if s ==# 'silent'
      silent execute a:cmd
    elseif s ==# 'silent!'
      silent! execute a:cmd
    else
      execute a:cmd
    endif
    redir END
    return output
  endfunction
endif

if has('nvim')
  function! s:system(cmd, ...) abort
    return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
  endfunction
  function! s:systemlist(cmd, ...) abort
    return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
  endfunction
else
  function! s:system(cmd, ...) abort
    if type(a:cmd) == 3
      let cmd = map(a:cmd, 'shellescape(v:val)')
      let cmd = join(cmd, ' ')
      return a:0 == 0 ? system(cmd) : system(cmd, a:1)
    else
      return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
    endif
  endfunction
  if exists('*systemlist')
    function! s:systemlist(cmd, ...) abort
      if type(a:cmd) == 3
        let cmd = map(a:cmd, 'shellescape(v:val)')
        let excmd = join(cmd, ' ')
        return a:0 == 0 ? systemlist(excmd) : systemlist(excmd, a:1)
      else
        return a:0 == 0 ? systemlist(a:cmd) : systemlist(a:cmd, a:1)
      endif
    endfunction
  else
    function! s:systemlist(cmd, ...) abort
      if type(a:cmd) == 3
        let cmd = map(a:cmd, 'shellescape(v:val)')
        let excmd = join(cmd, ' ')
        return a:0 == 0 ? split(system(excmd), "\n")
              \ : split(system(excmd, a:1), "\n")
      else
        return a:0 == 0 ? split(system(a:cmd), "\n")
              \ : split(system(a:cmd, a:1), "\n")
      endif
    endfunction
  endif
endif

if has('patch-7.4.279')
  function! s:globpath(dir, expr) abort
    return globpath(a:dir, a:expr, 1, 1)
  endfunction
else
  function! s:globpath(dir, expr) abort
    return split(globpath(a:dir, a:expr), '\n')
  endfunction
endif

" vim:set et sw=2 cc=80:
