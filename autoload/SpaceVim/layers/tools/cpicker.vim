"=============================================================================
" cpicker.vim
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section tools#cpicker, layers-tools-cpicker
" @parentsection layers
" The `tools#cpicker` layer provides a color picker.
" this layer is disabled by default, to enable this layer, add following
" snippet to your SpaceVim configuration file.
" >
"   [[layers]]
"     name = 'tools#cpicker'
" <
"
" @subsection Key bindings
" >
"   Key             Function
"   ---------------------------------------------
"   SPC i p c       open color picker
" <
"
" Key bindings in cpicker:
" >
"   Key             Function
"   ---------------------------------------------
"   <Enter>         copy color
"   j/<Down>        move cursor down
"   k/<Up>          move cursor up
"   h/<Left>        reduce
"   l/<Right>       increase
" <

function! SpaceVim#layers#tools#cpicker#plugins() abort

  return [
        \ [g:_spacevim_root_dir . 'bundle/cpicker.nvim', {'merged' : 0, 'loadconf' : 1, 'on_cmd' : 'Cpicker'}],
        \ ]

endfunction

function! SpaceVim#layers#tools#cpicker#config() abort

  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'c'], 'Cpicker all',
        \ 'insert-color-with-picker', 1)

endfunction

function! SpaceVim#layers#tools#cpicker#set_variable(var) abort
  let g:cpicker_default_format = get(a:var, 'default_format', 'hex')
endfunction

function! SpaceVim#layers#tools#cpicker#loadeable() abort

  return has('nvim-0.10.0')

endfunction
