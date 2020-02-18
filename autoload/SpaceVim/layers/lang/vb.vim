"=============================================================================
" vb.vim --- Visual Basic .NET support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#vb#config() abort
  call SpaceVim#plugins#runner#reg_runner('vb', ['vbc /utf8output /nologo /out:#TEMP# %s', '#TEMP#'])
  call SpaceVim#mapping#space#regesit_lang_mappings('vb', function('s:language_specified_mappings'))
endfunction
function! s:language_specified_mappings() abort
  call SpaceVim#mapping#space#langSPC('nmap', ['l','r'], 'call SpaceVim#plugins#runner#open()', 'execute current file', 1)
endf
