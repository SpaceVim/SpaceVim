"=============================================================================
" manager.vim --- plugin manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" Load SpaceVim api
let s:VIM_CO = SpaceVim#api#import('vim#compatible')
let s:JOB = SpaceVim#api#import('job')
let s:LIST = SpaceVim#api#import('data#list')


" init values
let s:plugins = []
let s:pulling_repos = {}

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
            if s:need_cmd('git')
                call s:VIM_CO.system([
                            \ 'git',
                            \ 'clone',
                            \ 'https://github.com/Shougo/neobundle.vim',
                            \ expand(g:spacevim_plugin_bundle_dir) . 'neobundle.vim'
                            \ ])
                let g:spacevim_neobundle_installed = 1
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
            if s:need_cmd('git')
                call s:VIM_CO.system([
                            \ 'git',
                            \ 'clone',
                            \ 'https://github.com/Shougo/dein.vim',
                            \ expand(g:spacevim_plugin_bundle_dir)
                            \ . join(['repos', 'github.com',
                            \ 'Shougo', 'dein.vim"'], s:Fsep)
                            \ ])
                let g:spacevim_dein_installed = 1
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
            if s:need_cmd('curl')

                call s:VIM_CO.system([
                            \ 'curl',
                            \ '-fLo',
                            \ expand('~/.cache/vim-plug/autoload/plug.vim'),
                            \ '--create-dirs',
                            \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
                            \ ])
                let g:spacevim_vim_plug_installed = 1
            endif
        endif
        exec 'set runtimepath+=~/.cache/vim-plug/'
    endif
endf

function! s:need_cmd(cmd) abort
    if executable(a:cmd)
        return 1
    else
        echohl WarningMsg
        echom '[SpaceVim] [plugin manager] You need install ' . a:cmd . '!'
        echohl None
        return 0
    endif
endfunction

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#update() abort
    let s:plugins = keys(dein#get())
    for i in range(g:spacevim_plugin_manager_max_processes)
        call s:pull(dein#get(s:LIST.shift(s:plugins)))
    endfor
endfunction
" @vimlint(EVL102, 0, l:i)

" here if a:data == 0, git pull succeed
function! s:on_pull_exit(id, data, event) abort
    "echom a:id . string(a:data) . string(a:event) . string(s:pulling_repos)
    if a:data == 0
        echom 'succeed to update ' . s:pulling_repos[a:id].name
    else
        echom 'failed to update ' . s:pulling_repos[a:id].name
    endif
    call s:msg_on_updated_done(s:pulling_repos[a:id].name)
    call remove(s:pulling_repos, string(a:id))
    if !empty(s:plugins)
        call s:pull(dein#get(s:LIST.shift(s:plugins)))
    endif
    if empty(s:pulling_repos)
        echom 'SpaceVim update done'
    endif

endfunction

function! s:pull(repo) abort
    let argv = ['git', '-C', a:repo.path, 'pull']
    let jobid = s:JOB.start(argv,{
                \ 'on_exit' : function('s:on_pull_exit')
                \ })
    if jobid != 0
        let s:pulling_repos[jobid] = a:repo
        call s:msg_on_start(a:repo.name)
    endif
endfunction

function! s:msg_on_start(name) abort
    " TODO update plugin manager ui
endfunction

function! s:msg_on_updated_done(name) abort
    " TODO update plugin manager ui
endfunction
