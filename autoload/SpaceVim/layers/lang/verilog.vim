"=============================================================================
" verilog.vim --- Verilog/SystemVerilog support
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section lang#verilog, layers-lang-verilog
" @parentsection layers
" This layer is for verilog development, disabled by default, to enable this
" layer, add following snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'lang#verilog'
" <

function! SpaceVim#layers#lang#verilog#plugins() abort
  let plugins = []
  call add(plugins, [g:_spacevim_root_dir . 'bundle/verilog', {'merged' : 0}])
  return plugins
endfunction


function! SpaceVim#layers#lang#verilog#config() abort

endfunction


function! SpaceVim#layers#lang#verilog#health() abort
  call SpaceVim#layers#lang#verilog#plugins()
  call SpaceVim#layers#lang#verilog#config()
  return 1
endfunction
