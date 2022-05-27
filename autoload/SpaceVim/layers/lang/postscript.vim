"=============================================================================
" postscript.vim --- PostScript language layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#postscript, layers-lang-postscript
" @parentsection layers
" This layer is for postscript development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#postscript'
" <
"

function! SpaceVim#layers#lang#postscript#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-postscript', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#postscript#config() abort

endfunction

function! SpaceVim#layers#lang#postscript#health() abort
  call SpaceVim#layers#lang#postscript#plugins()
  call SpaceVim#layers#lang#postscript#config()
  return 1
endfunction

