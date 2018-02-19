"=============================================================================
" tmux.vim --- SpaceVim tmux layer
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


""
" @section lang#tmux, layer-lang-tmux
" @parentsection layers
" @subsection Intro
" The lang#tmux layer provides syntax highlighting, commenting, man page navigation
" and ability to execute lines as tmux commands.
" @section(layer-checkers)

function! SpaceVim#layers#lang#tmux#plugins() abort
    let plugins = []
    call add(plugins, ['tmux-plugins/vim-tmux', {'on_ft' : 'tmux'}])
    return plugins
endfunction
