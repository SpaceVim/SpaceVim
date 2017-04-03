function! SpaceVim#api#vim#compatible#get() abort
  return map({
        \ 'execute' : '',
        \ 'system' : '',
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

if has('nvim')
  function! s:system(cmd, ...) abort
    return a:0 == 0 ? system(a:cmd) : system(a:cmd, a:1)
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
endif

" vim:set et sw=2 cc=80:
