function! SpaceVim#util#globpath(path, expr) abort
  if has('patch-7.4.279')
    return globpath(a:path, a:expr, 1, 1)
  else
    return split(globpath(a:path, a:expr), '\n')
  endif
endfunction

function! SpaceVim#util#findFileInParent(what, where) abort
    let old_suffixesadd = &suffixesadd
    let &suffixesadd = ''
    let file = findfile(a:what, escape(a:where, ' ') . ';')
    let &suffixesadd = old_suffixesadd
    return file
endfunction

function! SpaceVim#util#findDirInParent(what, where) abort
    let old_suffixesadd = &suffixesadd
    let &suffixesadd = ''
    let dir = finddir(a:what, escape(a:where, ' ') . ';')
    let &suffixesadd = old_suffixesadd
    return dir
endfunction

function! SpaceVim#util#echoWarn(msg) abort
  echohl WarningMsg
  echo a:msg
  echohl None
endfunction

function! SpaceVim#util#haspyxlib(lib) abort
  try
      exe 'pyx import ' . a:lib
  catch
    return 0
  endtry
  return 1
endfunction

function! SpaceVim#util#haspylib(lib)
  try
      exe 'py import ' . a:lib
  catch
    return 0
  endtry
  return 1
endfunction

function! SpaceVim#util#haspy3lib(lib)
  try
      exe 'py3 import ' . a:lib
  catch
    return 0
  endtry
  return 1
endfunction

" vim:set et sw=2 cc=80:
