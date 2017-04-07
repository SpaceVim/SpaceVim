"=============================================================================
" manager.vim --- plugin manager for SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: MIT license
"=============================================================================

" TODO add airline support for plugin manager
" TODO add install function for plugin manager

" Load SpaceVim api
let s:VIM_CO = SpaceVim#api#import('vim#compatible')
let s:JOB = SpaceVim#api#import('job')
let s:LIST = SpaceVim#api#import('data#list')


" init values
let s:plugins = []
let s:pulling_repos = {}
" key : plugin name, value : buf line number in manager buffer.
let s:ui_buf = {}
let s:plugin_manager_buffer = 0

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

function! s:get_uninstalled_plugins() abort
    return filter(values(dein#get()), '!isdirectory(v:val.path)')
endfunction

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#install(...) abort
    let s:plugins = a:0 == 0 ? sort(map(s:get_uninstalled_plugins(), 'v:val.name')) : sort(copy(a:1))
    if !s:new_window() || empty(s:plugins)
        echohl WarningMsg
        echom '[SpaceVim] [plugin manager] plugin manager process is not finished.'
        echohl None
        return
    endif
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf SpaceVimPlugManager
    nnoremap <silent> <buffer> q :bd<CR>
    let s:pct = 0
    let s:total = len(s:plugins)
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installing plugins (' . s:pct . '/' . s:total . ')')
    if has('nvim')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    else
        call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:append_buf_line(s:plugin_manager_buffer, 3, '')
    endif
    let s:start_time = reltime()
    for i in range(g:spacevim_plugin_manager_max_processes)
        if !empty(s:plugins)
            let repo = dein#get(s:LIST.shift(s:plugins))
            if !empty(repo)
                call s:install(repo)
            endif
        endif
    endfor
endfunction
" @vimlint(EVL102, 0, l:i)

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#update(...) abort
    if !s:new_window()
        echohl WarningMsg
        echom '[SpaceVim] [plugin manager] plugin updating is not finished.'
        echohl None
        return
    endif
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf SpaceVimPlugManager
    nnoremap <silent> <buffer> q :bd<CR>
    let s:pct = 0
    let s:plugins = a:0 == 0 ? sort(keys(dein#get())) : sort(copy(a:1))
    let s:total = len(s:plugins)
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct . '/' . s:total . ')')
    if has('nvim')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    else
        call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:append_buf_line(s:plugin_manager_buffer, 3, '')
    endif
    let s:start_time = reltime()
    for i in range(g:spacevim_plugin_manager_max_processes)
        if !empty(s:plugins)
            let repo = dein#get(s:LIST.shift(s:plugins))
            if !empty(repo)
                call s:pull(repo)
            endif
        endif
    endfor
endfunction
" @vimlint(EVL102, 0, l:i)

function! s:status_bar() abort
    let bar = '['
    let ct = 50 * s:pct / s:total
    let bar .= repeat('=', ct)
    let bar .= repeat(' ', 50 - ct)
    let bar .= ']'
    return bar
endfunction

" here if a:data == 0, git pull succeed
function! s:on_pull_exit(id, data, event) abort
    if a:data == 0 && a:event ==# 'exit'
        call s:msg_on_updated_done(s:pulling_repos[a:id].name)
    else
        call s:msg_on_updated_failed(s:pulling_repos[a:id].name)
    endif
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call remove(s:pulling_repos, string(a:id))
    if !empty(s:plugins)
        call s:pull(dein#get(s:LIST.shift(s:plugins)))
    endif
    if empty(s:pulling_repos)
        " TODO add elapsed time info.
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updated. Elapsed time: '
                    \ . split(reltimestr(reltime(s:start_time)))[0] . ' sec.')
        let s:plugin_manager_buffer = 0
        if g:spacevim_plugin_manager ==# 'dein'
            call dein#recache_runtimepath()
        endif
    endif

endfunction

" here if a:data == 0, git pull succeed
function! s:on_install_exit(id, data, event) abort
    if a:data == 0 && a:event ==# 'exit'
        call s:msg_on_install_done(s:pulling_repos[a:id].name)
    else
        call s:msg_on_install_failed(s:pulling_repos[a:id].name)
    endif
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installing plugins (' . s:pct . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call remove(s:pulling_repos, string(a:id))
    if !empty(s:plugins)
        call s:install(dein#get(s:LIST.shift(s:plugins)))
    endif
    if empty(s:pulling_repos)
        " TODO add elapsed time info.
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installed. Elapsed time: '
                    \ . split(reltimestr(reltime(s:start_time)))[0] . ' sec.')
        let s:plugin_manager_buffer = 0
        if g:spacevim_plugin_manager ==# 'dein'
            call dein#recache_runtimepath()
        endif
    endif
endfunction

function! s:pull(repo) abort
    let s:pct += 1
    let s:ui_buf[a:repo.name] = s:pct
    let argv = ['git', '-C', a:repo.path, 'pull']
    let jobid = s:JOB.start(argv,{
                \ 'on_exit' : function('s:on_pull_exit')
                \ })
    if jobid != 0
        let s:pulling_repos[jobid] = a:repo
        call s:msg_on_start(a:repo.name)
    endif
endfunction

function! s:install(repo) abort
    let s:pct += 1
    let s:ui_buf[a:repo.name] = s:pct
    let url = 'https://github.com/' . a:repo.repo
    let argv = ['git', 'clone', url, a:repo.path]
    let jobid = s:JOB.start(argv,{
                \ 'on_exit' : function('s:on_install_exit')
                \ })
    if jobid != 0
        let s:pulling_repos[jobid] = a:repo
        call s:msg_on_install_start(a:repo.name)
    endif
endfunction

" + foo.vim: Updating...
if has('nvim')
    function! s:msg_on_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
    function! s:msg_on_install_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
    endfunction
else
    function! s:msg_on_start(name) abort
        call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
    function! s:msg_on_install_start(name) abort
        call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
    endfunction
endif

" - foo.vim: Updating done.
function! s:msg_on_updated_done(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Updating done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_updated_failed(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Updating failed.')
endfunction

function! s:msg_on_install_process(name, status) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3,
                \ '- ' . a:name . ': Installing ' . a:status)
endfunction

" - foo.vim: Updating done.
function! s:msg_on_install_done(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Installing done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_install_failed(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Installing failed.')
endfunction

function! s:new_window() abort
    if s:plugin_manager_buffer != 0 && bufexists(s:plugin_manager_buffer)
        return 0
    else
        execute get(g:, 'spacevim_window', 'vertical topleft new')
        let s:plugin_manager_buffer = bufnr('%')
        return 1
    endif
endfunction

" change modifiable before setline
if has('nvim') && exists('*nvim_buf_set_lines') 
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        call nvim_buf_set_lines(a:bufnr, a:nr - 1, a:nr, 0, [a:line])
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
elseif has('python')
    py import vim
    py import string
    " @vimlint(EVL103, 1, a:bufnr)
    " @vimlint(EVL103, 1, a:nr)
    " @vimlint(EVL103, 1, a:line)
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        py bufnr = string.atoi(vim.eval("a:bufnr"))
        py linr = string.atoi(vim.eval("a:nr")) - 1
        py str = vim.eval("a:line")
        py vim.buffers[bufnr][linr] = str
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
    " @vimlint(EVL103, 0, a:bufnr)
    " @vimlint(EVL103, 0, a:nr)
    " @vimlint(EVL103, 0, a:line)

    " @vimlint(EVL103, 1, a:bufnr)
    " @vimlint(EVL103, 1, a:nr)
    " @vimlint(EVL103, 1, a:line)
    function! s:append_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        py bufnr = string.atoi(vim.eval("a:bufnr"))
        py linr = string.atoi(vim.eval("a:nr")) - 1
        py str = vim.eval("a:line")
        py vim.buffers[bufnr].append(str)
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
    " @vimlint(EVL103, 0, a:bufnr)
    " @vimlint(EVL103, 0, a:nr)
    " @vimlint(EVL103, 0, a:line)
endif
