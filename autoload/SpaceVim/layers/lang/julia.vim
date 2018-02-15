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
  if (has('nvim'))
    call add(plugins, ['JuliaEditorSupport/deoplete-julia', {'on_ft' : 'julia'}])
  endif
  call add(plugins, ['zyedidia/julialint.vim', {'on_ft' : 'julia'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  let g:latex_to_unicode_tab = 0
  au! BufNewFile,BufRead *.jl setf julia
  au! BufNewFile,BufRead *.julia setf julia
endfunction
