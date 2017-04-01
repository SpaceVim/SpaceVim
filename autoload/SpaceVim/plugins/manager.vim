"=============================================================================
" manager.vim --- plugin manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" install plugin manager 
function! s:install_manager() abort
    " Fsep && Psep
    if has('win16') || has('win32') || has('win64')
        let s:Psep = ';'
        let s:Fsep = '\'
    else
        let s:Psep = ':'
        let s:Fsep = '/'
    endif
    " auto install plugin manager
    if g:spacevim_plugin_manager ==# 'neobundle'
        "auto install neobundle
        if filereadable(expand(g:spacevim_plugin_bundle_dir)
                    \ . 'neobundle.vim'. s:Fsep. 'README.md')
            let g:spacevim_neobundle_installed = 1
        else
            if executable('git')
                exec '!git clone '
                            \ .'https://github.com/'
                            \ .'Shougo/neobundle.vim'
                            \ . ' '
                            \ . fnameescape(g:spacevim_plugin_bundle_dir)
                            \ . 'neobundle.vim'
                let g:spacevim_neobundle_installed = 1
            else
                echohl WarningMsg
                echom 'You need install git!'
                echohl None
            endif
        endif
        exec 'set runtimepath+='
                    \ . fnameescape(g:spacevim_plugin_bundle_dir)
                    \ . 'neobundle.vim'
    elseif g:spacevim_plugin_manager ==# 'dein'
        "auto install dein
        if filereadable(expand(g:spacevim_plugin_bundle_dir)
                    \ . join(['repos', 'github.com',
                    \ 'Shougo', 'dein.vim', 'README.md'],
                    \ s:Fsep))
            let g:spacevim_dein_installed = 1
        else
            if executable('git')
                exec '!git clone https://github.com/Shougo/dein.vim "'
                            \ . expand(g:spacevim_plugin_bundle_dir)
                            \ . join(['repos', 'github.com',
                            \ 'Shougo', 'dein.vim"'], s:Fsep)
                let g:spacevim_dein_installed = 1
            else
                echohl WarningMsg
                echom 'You need install git!'
                echohl None
            endif
        endif
        exec 'set runtimepath+='. fnameescape(g:spacevim_plugin_bundle_dir)
                    \ . join(['repos', 'github.com', 'Shougo',
                    \ 'dein.vim'], s:Fsep)
    elseif g:spacevim_plugin_manager ==# 'vim-plug'
        "auto install vim-plug
        if filereadable(expand('~/.cache/vim-plug/autoload/plug.vim'))
            let g:spacevim_vim_plug_installed = 1
        else
            if executable('curl')
                exec '!curl -fLo '
                            \ . '~/.cache/vim-plug/autoload/plug.vim'
                            \ . ' --create-dirs '
                            \ . 'https://raw.githubusercontent.com/'
                            \ . 'junegunn/vim-plug/master/plug.vim'
                let g:spacevim_vim_plug_installed = 1
            else
                echohl WarningMsg
                echom 'You need install curl!'
                echohl None
            endif
        endif
        exec 'set runtimepath+=~/.cache/vim-plug/'
    endif
endf
