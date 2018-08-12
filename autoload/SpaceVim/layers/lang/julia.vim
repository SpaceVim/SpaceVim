"=============================================================================
" julia.vim --- Julia Language configuration for SpaceVim
" Copyright (c) 2012-2016 Shidong Wang & Contributors
" Author: Jinxuan Zhu <zhujinxuan@gmail.com>
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#julia, layer-lang-julia
" @parentsection layers
" The layer provides synatax highlight julia. 
" The completeion only works in nvim with deoplete.
" However, the julia-vim could not be load on-demanding 
" due to its LaTeXToUnicode feature.
"

function! SpaceVim#layers#lang#julia#plugins() abort
  let plugins = []
  call add(plugins, ['JuliaEditorSupport/julia-vim' , {'merged' : 0}])
  if !SpaceVim#layers#lsp#check_filetype('julia')
    call add(plugins, ['JuliaEditorSupport/deoplete-julia', {'merged' : 0}])
  endif
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  call SpaceVim#plugins#repl#reg('julia', 'julia')
  let g:latex_to_unicode_tab = 0

  " julia
  let g:default_julia_version = '0.6'

  if SpaceVim#layers#lsp#check_filetype('julia')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
