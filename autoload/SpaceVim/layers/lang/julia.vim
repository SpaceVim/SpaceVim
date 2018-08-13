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
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  " registe code runner commmand for julia
  call SpaceVim#plugins#runner#reg_runner('julia', 'julia %s')
  " registe REPL command and key bindings for julia
  call SpaceVim#plugins#repl#reg('julia', 'julia')
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("julia")',
        \ 'start REPL process', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        \ 'call SpaceVim#plugins#repl#send("line")',
        \ 'send line and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        \ 'call SpaceVim#plugins#repl#send("buffer")',
        \ 'send buffer and keep code buffer focused', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        \ 'call SpaceVim#plugins#repl#send("selection")',
        \ 'send selection and keep code buffer focused', 1)
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
