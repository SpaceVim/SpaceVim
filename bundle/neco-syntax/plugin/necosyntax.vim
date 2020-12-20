"=============================================================================
" FILE: necosyntax.vim
" AUTHOR:  Jia Sui <jsfaint@gmail.com>
" License: MIT license
"=============================================================================

" Register source for NCM
autocmd User CmSetup call cm#register_source({
      \ 'name': 'neco-syntax',
      \ 'abbreviation': 'syntax',
      \ 'priority': 8,
      \ 'cm_refresh': 'cm#sources#necosyntax#refresh',
      \ 'cm_refresh_patterns': ['\w\+$'],
      \ })
