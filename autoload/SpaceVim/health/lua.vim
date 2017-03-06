function! SpaceVim#health#lua#check() abort
  let result = ['SpaceVim lua support check report:']
  call add(result, 'Checking +lua:')
  if has('nvim')
    if has('lua')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : Known issue, neovim do not support lua now.')
    endif
  else
    if has('lua')
      call add(result, '      SUCCEED!')
    else
      call add(result, '      Failed : to support +lua, you need recompile your vim with +lua support.')
    endif
  endif
  return result
endfunction

" vim:set et sw=2:
