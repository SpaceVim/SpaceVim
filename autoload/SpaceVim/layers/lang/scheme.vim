"=============================================================================
" scheme.vim --- lang#scheme layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

if exists('s:scheme_interpreter')
  " @bug s:scheme_interpreter always return 'scheme'
  "
  " because this script will be loaded twice. This is the feature of vim,
  " when call an autoload func, vim will try to load the script again
  finish
else
  let s:scheme_interpreter = 'scheme'
endif


function! SpaceVim#layers#lang#scheme#config() abort
  if s:scheme_interpreter ==# 'mit-scheme'
    call SpaceVim#plugins#runner#reg_runner('scheme', 'echo | mit-scheme --quiet --load %s && echo')
  elseif s:scheme_interpreter ==# 'guile'
    call SpaceVim#plugins#runner#reg_runner('scheme', 'echo | guile -q %s && echo')
  else
    call SpaceVim#plugins#runner#reg_runner('scheme', 'echo | ' . s:scheme_interpreter . ' %s && echo')
  endif
  call SpaceVim#mapping#space#regesit_lang_mappings('scheme', function('s:language_specified_mappings'))
  call SpaceVim#plugins#repl#reg('scheme', [s:scheme_interpreter, '--silent'])
endfunction


function! SpaceVim#layers#lang#scheme#set_variable(opt) abort
  let s:scheme_interpreter = get(a:opt, 'scheme_interpreter', s:scheme_interpreter) 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("scheme")',
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
