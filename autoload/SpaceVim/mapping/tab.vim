if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#tab#i_tab() abort
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
      return "\<C-n>"
    endif
    if index(g:spacevim_plugin_groups, 'autocomplete') != -1
      if neosnippet#expandable() && getline('.')[col('.')-2] ==# '(' && !pumvisible()
        return "\<Plug>(neosnippet_expand)"
      elseif neosnippet#jumpable()
            \ && getline('.')[col('.')-2] ==# '(' && !pumvisible() 
            \ && !neosnippet#expandable()
        return "\<plug>(neosnippet_jump)"
      elseif neosnippet#expandable_or_jumpable() && getline('.')[col('.')-2] !=#'('
        return "\<plug>(neosnippet_expand_or_jump)"
      elseif pumvisible()
        return "\<C-n>"
      else
        return "\<tab>"
      endif
    elseif pumvisible()
      return "\<C-n>"
    else
      return "\<tab>"
    endif
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
  function! SpaceVim#mapping#tab#i_tab() abort
    return "\<tab>"
  endfunction
endif
" vim:set et sw=2 cc=80:
