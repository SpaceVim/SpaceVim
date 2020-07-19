"=============================================================================
" julia.vim --- SpaceVim lang#julia layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#julia, layer-lang-julia
" @parentsection layers
" This layer is for julia development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#julia'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for julia, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

function! SpaceVim#layers#lang#julia#plugins() abort
  let plugins = []
  call add(plugins, ['JuliaEditorSupport/julia-vim' , {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#julia#config() abort
  " registe code runner commmand for julia
  call SpaceVim#plugins#runner#reg_runner('julia', 'julia %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('julia', function('s:language_specified_mappings'))
  " registe REPL command and key bindings for julia
  call SpaceVim#plugins#repl#reg('julia', 'julia')

  let g:latex_to_unicode_auto = 1
  let g:latex_to_unicode_tab = 1
  " runtime macros/matchit.vim

  " julia
  let g:default_julia_version = '0.7'
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 't'],
        \ 'call LaTeXtoUnicode#Toggle()', 'toggle latex to unicode', 1)
  if SpaceVim#layers#lsp#check_filetype('julia')
    nnoremap <silent><buffer> K :call SpaceVim#lsp#show_doc()<CR>
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
          \ 'call SpaceVim#lsp#show_doc()', 'show_document', 1)
    call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'e'],
          \ 'call SpaceVim#lsp#rename()', 'rename symbol', 1)
  endif
endfunction
