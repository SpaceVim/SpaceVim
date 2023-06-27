"=============================================================================
" statuscolumn.vim --- statuscolumn support for neovim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section core#statuscolumn, layers-core-statuscolumn
" @parentsection layers
" This layer provides a simple statuscolumn for SpaceVim and is disabled by
" default.
"
" To enable this layer, add following section to your configuration file.
" >
"   [[layers]]
"     name = 'core#statuscolumn'
"     enable = true
" <

function! SpaceVim#layers#core#statuscolumn#config() abort
		let &stc='%{substitute(v:lnum,"\\d\\zs\\ze\\'
          \ . '%(\\d\\d\\d\\)\\+$",",","g")}'
endfunction
function! SpaceVim#layers#core#statuscolumn#loadable() abort
  return exists('+statuscolumn')
endfunction

function! SpaceVim#layers#core#statuscolumn#health() abort

  return 1

endfunction

