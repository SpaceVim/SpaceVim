
if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#enter#i_enter() abort
    if pumvisible()
      if neosnippet#expandable_or_jumpable()
        return "\<plug>(neosnippet_expand_or_jump)"
      endif
    else
      return "\<Enter>"
    endif
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
endif
" vim:set et sw=2 cc=80:
