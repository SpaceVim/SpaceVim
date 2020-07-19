"=============================================================================
" coffeescript.vim --- lang#coffeescript layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#coffeescript, layer-lang-coffeescript
" @parentsection layers
" This layer is for coffeescript development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#coffeescript'
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <
"
" This layer also provides REPL support for coffeescript, the key bindings are:
" >
"   Key             Function
"   ---------------------------------------------
"   SPC l s i       Start a inferior REPL process
"   SPC l s b       send whole buffer
"   SPC l s l       send current line
"   SPC l s s       send selection text
" <
"

let s:SYS = SpaceVim#api#import('system')

function! SpaceVim#layers#lang#coffeescript#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-coffeescript', {'on_ft' : 'coffee'}])
  return plugins
endfunction


function! SpaceVim#layers#lang#coffeescript#config() abort
  call SpaceVim#plugins#runner#reg_runner('coffee', {
        \ 'exe' : 'coffee' . (s:SYS.isWindows ? '.CMD' : ''),
        \ 'usestdin' : 1,
        \ 'opt': ['-s'],
        \ })
  " call SpaceVim#plugins#runner#reg_runner('coffee', 'coffee %s')
  call SpaceVim#plugins#repl#reg('coffee', ['coffee' . (s:SYS.isWindows ? '.CMD' : ''), '-i'])
  call SpaceVim#mapping#space#regesit_lang_mappings('coffee', function('s:language_specified_mappings'))

endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("coffee")',
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
  let g:neomake_coffee_enabled_makers = ['coffee', 'coffeelint']
  let g:neomake_coffee_coffeelint_maker =  {
        \ 'args': ['--reporter=csv'],
        \ 'errorformat': '%f\,%l\,%\d%#\,%trror\,%m,' .
        \ '%f\,%l\,%trror\,%m,' .
        \ '%f\,%l\,%\d%#\,%tarn\,%m,' .
        \ '%f\,%l\,%tarn\,%m'
        \ }
  let g:neomake_coffee_coffeelint_remove_invalid_entries = 1
  let g:neomake_coffee_coffee_maker =  {
        \ 'args': [],
        \ 'output_stream': 'stderr',
        \ 'errorformat': '%f:%l:%c: %m',
        \ }
  let g:neomake_coffee_coffee_remove_invalid_entries = 1
  " \ 'filter_output' : function('s:filter_coffee_lint'),

  let g:neoformat_enabled_coffee = ['coffeefmt']
  let g:neoformat_coffee_coffeefmt = {
        \ 'exe': 'coffee-fmt',
        \ 'args': ['--indent_stype', 'space', '-i'],
        \ 'stdin': 0,
        \ }
endfunction


function! s:filter_coffee_lint(lines, job) abort
  let a:lines = []
endfunction
