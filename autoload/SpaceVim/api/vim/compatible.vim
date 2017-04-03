function! SpaceVim#api#vim#compatible#get() abort
  return map({
        \ 'execute' : '',
        \ },
        \ "function('s:' . v:key)"
        \ )
endfunction

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

" vim:set et sw=2 cc=80:
