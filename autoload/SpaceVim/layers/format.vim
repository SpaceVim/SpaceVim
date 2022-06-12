"=============================================================================
" format.vim --- format Layer file for SpaceVim
" Copyright (c) 2012-2022 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section format, layers-format
" @parentsection layers
" `format` layer provides code formation for SpaceVim, the default formatting
" plugin is `neoformat`, and you can also use `vim-codefmt`.
"
" @subsection layer options
"
" 1. `format_on_save`: disabled by default.
" 2. `format_method`: set the format plugin, default plugin is `neoformat`.
" You can also use `vim-codefmt`.
" 3. `silent_format`: Runs the formatter without any messages.
"
" @subsection key bindings
" >
"   Key binding     Description
"   SPC b f         format current buffer or selection lines
" <
" 

if exists('s:format_on_save')
  finish
else
  let s:format_method = 'neoformat'
  let s:format_on_save = 0
  let s:silent_format = 0
  let s:format_ft = []
endif

function! SpaceVim#layers#format#health() abort
  call SpaceVim#layers#format#plugins()
  call SpaceVim#layers#format#config()
  return 1
endfunction

function! SpaceVim#layers#format#plugins() abort
  if s:format_method ==# 'neoformat'
    return [
          \ [g:_spacevim_root_dir . 'bundle/neoformat', {'merged' : 0, 'loadconf' : 1, 'loadconf_before' : 1}],
          \ ]
  elseif s:format_method ==# 'codefmt'
    return [
          \ ['google/vim-maktaba', {'merged' : 0}],
          \ ['google/vim-glaive', {'merged' : 0, 'loadconf' : 1}],
          \ ['google/vim-codefmt', {'merged' : 0}],
          \ ]
  endif
endfunction

function! SpaceVim#layers#format#config() abort

  if s:format_method ==# 'neoformat'
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'Neoformat', 'format-code', 1)
  elseif s:format_method ==# 'codefmt'
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'FormatCode', 'format-code', 1)
  endif
  augroup spacevim_layer_format
    autocmd!
    if s:silent_format
      autocmd BufWritePre * silent! call s:format()
    else
      autocmd BufWritePre * call s:format()
    endif
  augroup END
endfunction

function! SpaceVim#layers#format#set_variable(var) abort
  let s:format_method = get(a:var, 'format_method', s:format_method)
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
  let s:silent_format = get(a:var, 'silent_format', s:silent_format)
endfunction

function! SpaceVim#layers#format#get_options() abort
  return ['format_method', 'format_on_save', 'silent_format']
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

    if s:format_method ==# 'neoformat'
      undojoin | Neoformat
    elseif s:format_method ==# 'codefmt'
      undojoin | FormatCode
    endif
  endif
endfunction
