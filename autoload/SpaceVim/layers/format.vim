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
  let s:format_ft = []
endif

function! SpaceVim#layers#format#plugins() abort
  return [
        \ [g:_spacevim_root_dir . 'bundle/neoformat', {'merged' : 0, 'loadconf' : 1 , 'loadconf_before' : 1}],
        \ ]
endfunction

function! SpaceVim#layers#format#config() abort
  call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'Neoformat', 'format-code', 1)
  augroup spacevim_layer_format
    autocmd!
    autocmd BufWritePre * undojoin | call s:format()
  augroup END
endfunction

function! SpaceVim#layers#format#set_variable(var) abort
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
endfunction

function! SpaceVim#layers#format#get_options() abort

  return ['format_on_save']

endfunction

function! SpaceVim#layers#format#add_filetype(ft) abort
  if get(a:ft, 'enable', 0)
    if index(s:format_ft, a:ft.filetype) ==# -1
      call add(s:format_ft, a:ft.filetype)
    endif
  else
    if index(s:format_ft, a:ft.filetype) !=# -1
      call remove(s:format_ft, a:ft.filetype)
    endif
  endif
endfunction

function! s:format() abort
  if !empty(&ft) &&
        \ ( index(s:format_ft, &ft) !=# -1 || s:format_on_save ==# 1)
    Neoformat
  endif
endfunction
