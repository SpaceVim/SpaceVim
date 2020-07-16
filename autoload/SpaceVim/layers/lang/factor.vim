"=============================================================================
" factor.vim --- factor language support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#factor#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-factor', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#factor#config() abort
  " call SpaceVim#plugins#repl#reg('prolog', 'swipl -q')
  call SpaceVim#plugins#runner#reg_runner('factor', 'factor.exe %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('factor', function('s:language_specified_mappings'))
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  " let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        " \ 'call SpaceVim#plugins#repl#start("factor")',
        " \ 'start REPL process', 1)
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'l'],
        " \ 'call SpaceVim#plugins#repl#send("line")',
        " \ 'send line and keep code buffer focused', 1)
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'b'],
        " \ 'call SpaceVim#plugins#repl#send("buffer")',
        " \ 'send buffer and keep code buffer focused', 1)
  " call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 's'],
        " \ 'call SpaceVim#plugins#repl#send("selection")',
        " \ 'send selection and keep code buffer focused', 1)
endfunction

" ref:
" - https://www.howtoforge.com/linux-factor-command/
" - https://medium.com/@jdxcode/12-factor-cli-apps-dd3c227a0e46
