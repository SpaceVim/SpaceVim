"=============================================================================
" ps1.vim --- SpaceVim lang#ps1 layer
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#powershell, layers-lang-powershell
" @parentsection layers
" This layer is for powershell development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#powershell'
" <
"
" @subsection Layer Options
" 1. `enabled_formatters`: set the default formatters of powershell, default is
" `['PowerShellBeautifier']`. you can also add `PSScriptAnalyzer` into the list.
" >
"   [[layers]]
"     name = 'lang#powershell'
"     enabled_formatters = ['PowerShellBeautifier']
" <
"
" @subsection Key bindings
" >
"   Mode            Key             Function
"   ---------------------------------------------
"   normal          SPC l r         run current file
" <

if exists('s:enabled_formatters')
  finish
else
  let s:enabled_formatters = ['']
endif

function! SpaceVim#layers#lang#powershell#plugins() abort
  let plugins = []
  call add(plugins, ['wsdjeg/vim-powershell', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#powershell#config() abort
  call SpaceVim#plugins#repl#reg('powershell', 'powershell  -NoLogo -NoProfile -NonInteractive')
  call SpaceVim#plugins#runner#reg_runner('powershell', 'powershell %s')
  call SpaceVim#mapping#space#regesit_lang_mappings('powershell', function('s:language_specified_mappings'))
  let g:neoformat_enabled_powershell = s:enabled_formatters
endfunction

function! SpaceVim#layers#lang#powershell#set_variable(opt) abort
  let s:enabled_formatters = get(a:opt, 'enabled_formatters', s:enabled_formatters) 
endfunction

function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
  let g:_spacevim_mappings_space.l.s = {'name' : '+Send'}
  call SpaceVim#mapping#space#langSPC('nmap', ['l','s', 'i'],
        \ 'call SpaceVim#plugins#repl#start("powershell")',
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

function! SpaceVim#layers#lang#powershell#health() abort
  call SpaceVim#layers#lang#powershell#plugins()
  call SpaceVim#layers#lang#powershell#config()
  return 1
endfunction
