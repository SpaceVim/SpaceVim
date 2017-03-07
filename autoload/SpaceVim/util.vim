function! SpaceVim#util#globpath(path, expr) abort
  if has('patch-7.4.279')
    return globpath(a:path, a:expr, 1, 1)
  else
    return split(globpath(a:path, a:expr), '\n')
  endif
endfunction

function! SpaceVim#util#echoWarn(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

" vim:set et sw=2 cc=80:
