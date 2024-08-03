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
" @subsection layer options
" 1. default_spaces: set the default color spaces, the default value is `['rgb', 'hsl']`
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
" @subsection commands
" Instead of using key Binding, this layer also provides a Neovim command `:Cpicker` which can be used in cmdline. For example:
" >
"   :Cpicker rgb cmyk
" <

let s:default_spaces = ['rgb', 'hsl']

function! SpaceVim#layers#tools#cpicker#plugins() abort

  return [
        \ [g:_spacevim_root_dir . 'bundle/cpicker.nvim', {'merged' : 0, 'loadconf' : 1}],
        \ ]

endfunction

function! SpaceVim#layers#tools#cpicker#config() abort

  call SpaceVim#mapping#space#def('nnoremap', ['i', 'p', 'c'], 'Cpicker ' . join(s:default_spaces, ' '),
        \ 'insert-color-with-picker', 1)

endfunction

function! SpaceVim#layers#tools#cpicker#set_variable(var) abort
  let s:default_spaces = get(a:var, 'default_spaces', s:default_spaces)
endfunction

function! SpaceVim#layers#tools#cpicker#loadeable() abort

  return has('nvim-0.10.0')

endfunction

function! SpaceVim#layers#tools#cpicker#health() abort

  return 1

endfunction
