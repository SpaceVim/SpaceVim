"=============================================================================
" tab.vim --- tab key binding
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#tab#i_tab() abort
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
      return "\<C-n>"
    endif
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
    elseif complete_parameter#jumpable(1) && getline('.')[col('.')-2] !=# ')'
      return "\<plug>(complete_parameter#goto_next_parameter)"
    else
      return "\<tab>"
    endif
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
  function! SpaceVim#mapping#tab#expandable() abort
    let snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
      return snippet
    elseif pumvisible()
      return "\<C-n>"
    else
      return "\<TAB>"
    endif
  endfunction
  function! SpaceVim#mapping#tab#i_tab() abort
    if getline('.')[col('.')-2] ==# '{'&& pumvisible()
      return "\<C-n>"
    endif
    return "\<C-R>=SpaceVim#mapping#tab#expandable()\<cr>"
  endfunction
endif


" vim:set et sw=2 cc=80:
