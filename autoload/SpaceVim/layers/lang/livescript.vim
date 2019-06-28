"=============================================================================
" livescript.vim --- LiveScript support in SpaceVim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#livescript, layer-lang-livescript
" @parentsection layers
" This layer is for livescript development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#livescript'
" <
"
" @subsection Key bindings
" >
"   Mode      Key           Function
"   -------------------------------------------------------------
"   normal    SPC l r       run current file
" <
"
" This layer also provides REPL support for livescript, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"


function! SpaceVim#layers#lang#livescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-livescript', { 'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#livescript#config() abort
  call SpaceVim#plugins#repl#reg('livescript', 'lsc')
  call SpaceVim#plugins#runner#reg_runner('livescript', 'lsc %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('livescript', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("livescript")',
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
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l','e'], 'call call('
        \ . string(function('s:eval')) . ', [])',
        \ 'eval code::String', 1)

  " checker layer configuration
  if SpaceVim#layers#isLoaded('checkers') && g:spacevim_enable_neomake
    let g:neomake_livescript_enabled_makers = ['lsc']
    " Failed at: test.ls
    " { Error: Parse error on line 1: Unexpected 'NEWLINE'
    " at test.ls
    let g:neomake_livescript_lsc_maker =  {
          \ 'args': ['-c',],
          \ 'errorformat': '%EFailed at: %f,%C{\ Error:\ Parse\ error\ on\ line\ %l:\ %m',
          \ 'cwd': '%:p:h',
          \ }
    " Failed at: test.ls
    " SyntaxError: missing `"` on line 5
    " at test.ls
    let g:neomake_livescript_lsc_maker.errorformat .= ',%EFailed at: %f,%CSyntaxError:\ %m\ on\ line\ %l'
    let g:neomake_livescript_lsc_remove_invalid_entries = 1
  endif
endfunction


function! s:eval() abort
  let input = input('>>')
  let cmd = ['lsc', '-e', input, expand('%:p')]
  " @todo fix livescript eval function
endfunction
