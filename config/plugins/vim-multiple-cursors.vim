if g:spacevim_autocomplete_method ==# 'ycm'
  function! s:disable_autocomplete() abort

  endfunction
  function! s:enable_autocomplete() abort

  endfunction
elseif g:spacevim_autocomplete_method ==# 'neocomplete'
  function! s:disable_autocomplete() abort
    NeoCompleteLock
  endfunction
  function! s:enable_autocomplete() abort
    NeoCompleteUnlock
  endfunction
elseif g:spacevim_autocomplete_method ==# 'neocomplcache' "{{{
  function! s:disable_autocomplete() abort
    NeoComplCacheDisable
  endfunction
  function! s:enable_autocomplete() abort
    NeoComplCacheEnable
  endfunction
elseif g:spacevim_autocomplete_method ==# 'deoplete'
  function! s:disable_autocomplete() abort
    call deoplete#disable()
  endfunction
  function! s:enable_autocomplete() abort
    call deoplete#enable()
  endfunction
endif

" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  call s:disable_autocomplete()
  if g:spacevim_autocomplete_parens
    try
      let b:saved_delimitMate_statues = b:delimitMate_enabled
      echom execute('imap "')
      DelimitMateOff
      echom execute('imap "')
    catch
    endtry
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  call s:enable_autocomplete()
  if g:spacevim_autocomplete_parens
    try
      if b:saved_delimitMate_statues
      echom execute('imap "')
        silent! DelimitMateOn
      echom execute('imap "')
      endif
    catch
    endtry
  endif
endfunction
" vim:set et sw=2 cc=80:
