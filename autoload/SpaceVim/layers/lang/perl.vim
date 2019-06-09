"=============================================================================
" perl.vim --- SpaceVim lang#perl layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:SYS = SpaceVim#api#import('system')

function! SpaceVim#layers#lang#perl#plugins() abort
  let plugins = []
  call add(plugins, ['c9s/perlomni.vim', {'on_ft' : 'perl'}])
  call add(plugins, ['vim-perl/vim-perl', {'on_ft' : 'perl'}])
  call add(plugins, ['wsdjeg/perldoc-vim', {'on_cmd' : 'Perldoc'}])
  return plugins
endfunction

function! SpaceVim#layers#lang#perl#config() abort
  let g:perldoc_no_default_key_mappings = 1
  call SpaceVim#plugins#runner#reg_runner('perl', {
        \ 'exe' : 'perl',
        \ 'opt' : ['-'],
        \ 'usestdin' : 1,
        \ })
  call SpaceVim#mapping#space#regesit_lang_mappings('perl', function('s:language_specified_mappings'))
  if executable('perli')
    call SpaceVim#plugins#repl#reg('perl', ['perli'. (s:SYS.isWindows ? '.CMD' : '')])
  else
    call SpaceVim#plugins#repl#reg('perl', ['perl', '-del'])
  endif
endfunction
function! s:language_specified_mappings() abort
  nnoremap <silent><buffer> K :Perldoc<CR>
  call SpaceVim#mapping#space#langSPC('nnoremap', ['l', 'd'],
        \ 'Perldoc', 'show_document', 1)
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'],
        \ 'call SpaceVim#plugins#runner#open()',
        \ 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("perl")',
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
endfunction
