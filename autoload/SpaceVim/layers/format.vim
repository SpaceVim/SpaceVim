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
" You can also use `vim-codefmt` or `format.nvim`, `format.nvim` requires
" neovim 0.9.0+.
" 3. `silent_format`: Runs the formatter without any messages.
" 4. `format_notify_width`: set the neoformat notify window width.
" 5. `format_notify_timeout`: set the neoformat notify clear timeout. default
" is 5000 milliseconds.
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
  let s:format_notify_timeout = 5000
  let s:format_notify_width = &columns * 0.50
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
  elseif s:format_method ==# 'format.nvim'
    return [
          \ [g:_spacevim_root_dir . 'bundle/format.nvim', {'merged' : 0, 'loadconf' : 1, 'loadconf_before' : 1}],
          \ ]
  endif
endfunction

function! SpaceVim#layers#format#config() abort

  if s:format_method ==# 'neoformat'
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], ":Neoformat\<Cr>", 'format-code', 0, 1)
  elseif s:format_method ==# 'codefmt'
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], 'FormatCode', 'format-code', 1)
  elseif s:format_method ==# 'format.nvim'
    call SpaceVim#mapping#space#def('nnoremap', ['b', 'f'], ":Format\<Cr>", 'format-code', 0, 1)
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
  if has_key(a:var, 'format_method') && a:var.format_method ==# 'format.nvim' && !has('nvim-0.9.0')
    call SpaceVim#logger#info('format.nvim requires neovim 0.9.0+')
  else
    let s:format_method = get(a:var, 'format_method', s:format_method)
  endif
  let s:format_on_save = get(a:var, 'format_on_save', s:format_on_save)
  let s:silent_format = get(a:var, 'silent_format', s:silent_format)
  let s:format_notify_width = get(a:var, 'format_notify_width', s:format_notify_width)
  let s:format_notify_timeout = get(a:var, 'format_notify_timeout', s:format_notify_timeout)
endfunction

function! SpaceVim#layers#format#get_format_option() abort

  return {
        \ 'format_notify_width' : s:format_notify_width,
        \ 'format_notify_timeout' : s:format_notify_timeout,
        \ }

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
    elseif s:format_method ==# 'format.nvim'
      undojoin | Format
    endif
  endif
endfunction

function! SpaceVim#layers#format#loadable() abort

  return 1

endfunction
