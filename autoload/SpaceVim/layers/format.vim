"=============================================================================
" format.vim --- format Layer file for SpaceVim
" Copyright (c) 2012-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section format, layer-format
" @parentsection layers
" format layer provides code formation for SpaceVim, the default formatting
" plugin is |neoformat|.
" @subsection options
" format_on_save: disabled by default.
"
" 

if exists('s:format_on_save')
  finish
else
  let s:format_on_save = 0
endif

function! SpaceVim#layers#format#plugins() abort
    return [
                \ [g:_spacevim_root_dir . 'bundle/neoformat', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}],
                \ ]
endfunction

function! SpaceVim#layers#format#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'Neoformat', 'format-code', 1)
endfunction

function! SpaceVim#layers#format#set_variable(var) abort
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
endfunction

function! SpaceVim#layers#format#get_options() abort

  return ['format_on_save']

endfunction
