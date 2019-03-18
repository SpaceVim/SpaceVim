" ================================================================================
" vim-multiple-cursors settings
" ================================================================================
scriptencoding utf-8


if get(g:, 'spacevim_autocomplete_method', get(g:, 'autocomplete_method', 'deoplete')) ==# 'coc'
  function! s:disable_autocomplete() abort
    CocDisable
  endfunction
  function! s:enable_autocomplete() abort
    CocEnable
  endfunction
elseif get(g:, 'spacevim_autocomplete_method', get(g:, 'autocomplete_method', 'deoplete')) ==# 'ncm2'
  function! s:disable_autocomplete() abort
    call ncm2#lock('vim-multiple-cursors')
  endfunction
  function! s:enable_autocomplete() abort
    call ncm2#unlock('vim-multiple-cursors')
  endfunction
elseif get(g:, 'spacevim_autocomplete_method', get(g:, 'autocomplete_method', 'deoplete')) ==# 'deoplete'
  function! s:disable_autocomplete() abort
    call deoplete#disable()
  endfunction
  function! s:enable_autocomplete() abort
    call deoplete#enable()
  endfunction
elseif get(g:, 'spacevim_autocomplete_method', get(g:, 'autocomplete_method', 'deoplete')) ==# 'neocomplete'
  function! s:disable_autocomplete() abort
    NeoCompleteLock
  endfunction
  function! s:enable_autocomplete() abort
    NeoCompleteUnlock
  endfunction
endif


" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  call s:disable_autocomplete()
endfunction
" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  call s:enable_autocomplete()
endfunction
" vim:set et sw=2 cc=80:
