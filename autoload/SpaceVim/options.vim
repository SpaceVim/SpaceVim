function! SpaceVim#options#list() abort
  let list = []
  if has('patch-7.4.2010') && 0
    for var in getcompletion('g:spacevim_','var')
      call add(list, var . ' = ' . string(get(g:, var[2:] , '')))
    endfor
  else
    redraw
    for var in filter(map(s:execute('let g:'), "matchstr(v:val, '\\S\\+')"), "v:val =~# '^spacevim_'")
      call add(list,'g:' . var . ' = ' . string(get(g:, var , '')))
    endfor
  endif
  return list
endfunction

function! SpaceVim#options#set(argv, ...) abort
  if a:0 > 0
    if exists('g:spacevim_' . a:argv)
      exe 'let g:spacevim_' . a:argv . '=' . a:1
    endif
  else
    if exists('g:spacevim_' . a:argv)
      exe 'echo string(g:spacevim_' . a:argv . ')'
    endif
  endif
endfunction

function! s:execute(cmd) abort
  if exists('*execute')
    return split(execute(a:cmd), "\n")
  endif

  redir => output
  execute a:cmd
  redir END
  return split(output, "\n")
endfunction

" vim:set et sw=2:
