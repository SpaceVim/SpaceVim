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
" The layer provides synatax highlight and linting for julia. 
" The completeion only works in nvim with deoplete.
" However, the julia-vim could not be load on-demanding 
" due to its LaTeXToUnicode feature.
"

function! SpaceVim#layers#lang#julia#plugins() abort
  let plugins = []
  call add(plugins, ['JuliaEditorSupport/julia-vim' ])
  call add(plugins, ['zyedidia/julialint.vim', {'on_ft' : 'julia'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  let g:latex_to_unicode_tab = 0
  au! BufNewFile,BufRead *.jl setf julia
  au! BufNewFile,BufRead *.julia setf julia
  
  " julia
  let g:default_julia_version = '0.6'

  " language server
  let g:LanguageClient_autoStart = 1
  
  nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
  nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
  nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
endfunction
