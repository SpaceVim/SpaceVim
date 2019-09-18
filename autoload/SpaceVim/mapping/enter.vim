"=============================================================================
" enter.vim --- Enter key bindings
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
if g:spacevim_snippet_engine ==# 'neosnippet'
  function! SpaceVim#mapping#enter#i_enter() abort
    if pumvisible()
      if neosnippet#expandable()
        return "\<plug>(neosnippet_expand)"
      else
        return "\<c-y>"
      endif
    elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
      return "\<Enter>\<esc>ko"
    elseif getline('.')[col('.') - 2]==#'('&&getline('.')[col('.')-1]==#')'
      return "\<Enter>\<esc>ko"
    else
      return "\<Enter>"
    endif
  endfunction
elseif g:spacevim_snippet_engine ==# 'ultisnips'
  function! SpaceVim#mapping#enter#i_enter() abort
    if pumvisible()
      return "\<c-y>"
    elseif getline('.')[col('.') - 2]==#'{'&&getline('.')[col('.')-1]==#'}'
      return "\<Enter>\<esc>ko"
    else
      return "\<Enter>"
    endif
  endfunction
endif
" vim:set et sw=2 cc=80:
