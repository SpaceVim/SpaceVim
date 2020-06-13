"=============================================================================
" FILE: neoinclude.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
"=============================================================================

if exists('g:loaded_neoinclude')
  finish
endif

" Add commands.
command! -complete=buffer -nargs=? NeoIncludeMakeCache
      \ call neoinclude#include#make_cache(<q-args>)

let g:loaded_neoinclude = 1

" Register source for NCM
autocmd User CmSetup call cm#register_source({
      \ 'name': 'neoinclude',
      \ 'abbreviation': 'FI',
      \ 'priority': 8,
      \ 'cm_refresh': 'cm#sources#neoinclude#refresh',
      \ 'cm_refresh_min_word_len': 0,
      \ })
