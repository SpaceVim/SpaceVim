"=============================================================================
" octave.vim --- lang#octave layer
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#octave, layers-lang-octave
" @parentsection layers
" This layer adds syntax highlighting for the GNU Octave.
" It is disabled by default, to enable this layer, add following snippet to your
" SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#octave'
" <
"

function! SpaceVim#layers#lang#octave#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/vim-octave', {'merged' : 0}])
  return plugins
endfunction

function! SpaceVim#layers#lang#octave#config() abort
  
endfunction

function! SpaceVim#layers#lang#octave#health() abort
  call SpaceVim#layers#lang#octave#plugins()
  call SpaceVim#layers#lang#octave#config()
  return 1
endfunction
