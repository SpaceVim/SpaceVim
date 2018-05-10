"=============================================================================
" typescript.vim --- lang#typescript layer for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


function! SpaceVim#layers#lang#typescript#plugins() abort
  let plugins = []
  call add(plugins, ['leafgarland/typescript-vim'])
  if has('nvim')
    call add(plugins, ['mhartington/nvim-typescript'])
  else
    call add(plugins, ['Quramy/tsuquyomi'])
  endif
  return plugins
endfunction

let s:auto_fix = 0

function! SpaceVim#layers#lang#typescript#set_variable(var) abort
  if has('nvim')
    let  g:nvim_typescript#server_path =
          \ get(a:var, 'typescript_server_path',
          \ './node_modules/.bin/tsserver')
  else
    let tsserver_path = get(a:var, 'typescript_server_path', '')
    if !empty(tsserver_path)
      let g:tsuquyomi_use_dev_node_module = 2
      let g:tsuquyomi_tsserver_path = tsserver_path
    endif
  endif
  let s:auto_fix = get(a:var, 'auto_fix', 0)
endfunction


function! SpaceVim#layers#lang#typescript#config() abort
  if s:auto_fix
    let g:neomake_typescript_tslint_args = ['--fix']
    augroup SpaceVim_lang_typescript
      autocmd!
      autocmd User NeomakeFinished checktime
      autocmd FocusGained * checktime
    augroup END
  else 
    augroup SpaceVim_lang_typescript
      autocmd!
    augroup END
  endif

  if !has('nvim')
    augroup SpaceVim_lang_typescript
      autocmd FileType typescript setlocal omnifunc=tsuquyomi#complete
    augroup END
  endif
endfunction
