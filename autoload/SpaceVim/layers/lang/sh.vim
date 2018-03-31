"=============================================================================
" sh.vim --- SpaceVim lang#sh layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! SpaceVim#layers#lang#sh#plugins() abort
    let l:plugins = []
    call add(l:plugins, ['chrisbra/vim-zsh', { 'on_ft' : 'zsh' }])
    if get(g:, 'spacevim_enable_ycm') == 1
        call add(l:plugins, ['Valodim/vim-zsh-completion', { 'on_ft' : 'zsh' }])
    else
        call add(l:plugins, ['zchee/deoplete-zsh', { 'on_ft' : 'zsh' }])
    endif
    return l:plugins
endfunction

function! SpaceVim#layers#lang#sh#config()
  " chrisbra/vim-zsh {{{
  let g:zsh_fold_enable = 1
  " }}}

    call SpaceVim#layers#edit#add_ft_head_tamplate('sh',
                \ ['#!/usr/bin/env bash',
                \ '']
                \ )
  call SpaceVim#layers#edit#add_ft_head_tamplate('zsh', [
      \ '#!/usr/bin/env zsh',
      \ ''
      \ ])
  augroup spacevim_layer_lang_sh
    autocmd!
    autocmd FileType sh setlocal omnifunc=SpaceVim#plugins#bashcomplete#omnicomplete
  augroup END
endfunction
