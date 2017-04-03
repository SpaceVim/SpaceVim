
if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#enter#i_enter() abort
    if pumvisible()
      if neosnippet#expandable()
        return "\<plug>(neosnippet_expand)"
      else
        return "\<c-y>"
      endif
    else
      return "\<Enter>"
    endif
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
  function! SpaceVim#mapping#enter#i_enter() abort
    if pumvisible()
      return "\<c-y>"
    else
      return "\<Enter>"
    endif
  endfunction
endif
" vim:set et sw=2 cc=80:
