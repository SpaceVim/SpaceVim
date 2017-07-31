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
let s:building_repos = {}
" key : plugin name, value : buf line number in manager buffer.
let s:ui_buf = {}
let s:plugin_manager_buffer = 0
let s:plugin_manager_buffer_lines = []
let s:jobpid = 0

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
    if !s:JOB.vim_job && !s:JOB.nvim_job
        let &maxfuncdepth = 2000
    endif
    let s:plugins = a:0 == 0 ? sort(map(s:get_uninstalled_plugins(), 'v:val.name')) : sort(copy(a:1))
    if empty(s:plugins)
        echohl WarningMsg
        echom '[SpaceVim] Wrong plugin name, or all of the plugins are already installed.'
        echohl None
        return
    endif
    let status = s:new_window()
    if status == 0
        echohl WarningMsg
        echom '[SpaceVim] [plugin manager] plugin manager process is not finished.'
        echohl None
        return
    elseif status == 1
        " resume window
        return
    endif
    let s:pct = 0
    let s:pct_done = 0
    let s:total = len(s:plugins)
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Installing plugins (' . s:pct_done . '/' . s:total . ')')
    if has('nvim')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    elseif has('python')
        call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:append_buf_line(s:plugin_manager_buffer, 3, '')
    else
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
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
    if !s:JOB.vim_job && !s:JOB.nvim_job
        let &maxfuncdepth = 100
    endif
endfunction
" @vimlint(EVL102, 0, l:i)

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#update(...) abort
    if !s:JOB.vim_job && !s:JOB.nvim_job
        let &maxfuncdepth = 2000
    endif
    let status = s:new_window()
    if status == 0
        echohl WarningMsg
        echom '[SpaceVim] [plugin manager] plugin updating is not finished.'
        echohl None
        return
    elseif status == 1
        return
    endif
    redraw!
    let s:pct = 0
    let s:pct_done = 0
    if exists('s:recache_done')
        unlet s:recache_done
    endif
    let s:plugins = a:0 == 0 ? sort(keys(dein#get())) : sort(copy(a:1))
    if a:0 == 0
        call add(s:plugins, 'SpaceVim')
    endif
    let s:total = len(s:plugins)
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    if has('nvim')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    elseif has('python')
        call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:append_buf_line(s:plugin_manager_buffer, 3, '')
    else
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    endif
    let s:start_time = reltime()
    for i in range(g:spacevim_plugin_manager_max_processes)
        if !empty(s:plugins)
            let reponame = s:LIST.shift(s:plugins)
            let repo = dein#get(reponame)
            if !empty(repo)
                call s:pull(repo)
            elseif reponame ==# 'SpaceVim'
                let repo = {
                            \ 'name' : 'SpaceVim',
                            \ 'path' : expand('~/.SpaceVim')
                            \ }
                call s:pull(repo)

            endif
        endif
    endfor
    if !s:JOB.vim_job && !s:JOB.nvim_job
        let &maxfuncdepth = 100
    endif
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
    if a:id == -1
        let id = s:jobpid
    else
        let id = a:id
    endif
    if a:data == 0 && a:event ==# 'exit'
        call s:msg_on_updated_done(s:pulling_repos[id].name)
    else
        call s:msg_on_updated_failed(s:pulling_repos[id].name)
    endif
    if a:id == -1
        redraw!
    endif
    if !empty(get(s:pulling_repos[id], 'build', ''))
        call s:build(s:pulling_repos[id])
    else
        let s:pct_done += 1
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    endif
    call remove(s:pulling_repos, string(id))
    if !empty(s:plugins)
        let name = s:LIST.shift(s:plugins)
        if name ==# 'SpaceVim'
            let repo = {
                        \ 'name' : 'SpaceVim',
                        \ 'path' : expand('~/.SpaceVim')
                        \ }
        else
            let repo = dein#get(name)
        endif
        call s:pull(repo)
    endif
    call s:recache_rtp(a:id)
endfunction


function! s:recache_rtp(id) abort
    if empty(s:pulling_repos) && empty(s:building_repos) && !exists('s:recache_done')
        " TODO add elapsed time info.
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updated. Elapsed time: '
                    \ . split(reltimestr(reltime(s:start_time)))[0] . ' sec.')
        let s:plugin_manager_buffer = 0
        if g:spacevim_plugin_manager ==# 'dein'
            call dein#recache_runtimepath()
        endif
        if a:id == -1
            let s:recache_done = 1
        endif
    endif

endfunction

" @vimlint(EVL103, 1, a:event)
function! s:on_install_stdout(id, data, event) abort
    if a:id == -1
        let id = s:jobpid
    else
        let id = a:id
    endif
    for str in a:data
        let status = matchstr(str,'\d\+%\s(\d\+/\d\+)')
        if !empty(status)
            call s:msg_on_install_process(s:pulling_repos[id].name, status)
        endif
    endfor
endfunction
" @vimlint(EVL103, 0, a:event)

function! s:lock_revision(repo) abort
    let cmd = ['git', '-C', a:repo.path, 'checkout', a:repo.rev]
    call s:VIM_CO.system(cmd)
endfunction

function! s:on_build_exit(id, data, event) abort
    if a:id == -1
        let id = s:jobpid
    else
        let id = a:id
    endif
    if a:data == 0 && a:event ==# 'exit'
        call s:msg_on_build_done(s:building_repos[id].name)
    else
        call s:msg_on_build_failed(s:building_repos[id].name)
    endif
    let s:pct_done += 1
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
    call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    call remove(s:building_repos, string(id))
    call s:recache_rtp(a:id)
endfunction

" here if a:data == 0, git pull succeed
function! s:on_install_exit(id, data, event) abort
    if a:id == -1
        let id = s:jobpid
    else
        let id = a:id
    endif
    if a:data == 0 && a:event ==# 'exit'
        call s:msg_on_install_done(s:pulling_repos[id].name)
    else
        call s:msg_on_install_failed(s:pulling_repos[id].name)
    endif
    if get(s:pulling_repos[id], 'rev', '') !=# ''
        call s:lock_revision(s:pulling_repos[id])
    endif
    if !empty(get(s:pulling_repos[id], 'build', ''))
        call s:build(s:pulling_repos[id])
    else
        let s:pct_done += 1
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct_done . '/' . s:total . ')')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
    endif
    call remove(s:pulling_repos, string(id))
    if !empty(s:plugins)
        call s:install(dein#get(s:LIST.shift(s:plugins)))
    endif
    call s:recache_rtp(a:id)
endfunction

function! s:pull(repo) abort
    let s:pct += 1
    let s:ui_buf[a:repo.name] = s:pct
    let argv = ['git', '-C', a:repo.path, 'pull', '--progress']
    if s:JOB.vim_job || s:JOB.nvim_job
        let jobid = s:JOB.start(argv,{
                    \ 'on_stderr' : function('s:on_install_stdout'),
                    \ 'on_exit' : function('s:on_pull_exit')
                    \ })
        if jobid != 0
            let s:pulling_repos[jobid] = a:repo
            call s:msg_on_start(a:repo.name)
        endif
    else
        let s:jobpid += 1
        let s:pulling_repos[s:jobpid] = a:repo
        call s:msg_on_start(a:repo.name)
        redraw!
        call s:JOB.start(argv,{
                    \ 'on_exit' : function('s:on_pull_exit')
                    \ })

    endif
endfunction

function! s:install(repo) abort
    let s:pct += 1
    let s:ui_buf[a:repo.name] = s:pct
    let url = 'https://github.com/' . a:repo.repo
    let argv = ['git', 'clone', '--progress', url, a:repo.path]
    if s:JOB.vim_job || s:JOB.nvim_job
        let jobid = s:JOB.start(argv,{
                    \ 'on_stderr' : function('s:on_install_stdout'),
                    \ 'on_exit' : function('s:on_install_exit')
                    \ })
        if jobid != 0
            let s:pulling_repos[jobid] = a:repo
            call s:msg_on_install_start(a:repo.name)
        endif
    else
        let s:jobpid += 1
        let s:pulling_repos[s:jobpid] = a:repo
        call s:msg_on_start(a:repo.name)
        redraw!
        call s:JOB.start(argv,{
                    \ 'on_stderr' : function('s:on_install_stdout'),
                    \ 'on_exit' : function('s:on_install_exit')
                    \ })

    endif
endfunction

function! s:build(repo) abort
    let argv = type(a:repo.build) != 4 ? a:repo.build : s:get_build_argv(a:repo.build)
    if s:JOB.vim_job || s:JOB.nvim_job
        let jobid = s:JOB.start(argv,{
                    \ 'on_exit' : function('s:on_build_exit'),
                    \ 'cwd' : a:repo.path,
                    \ })
        if jobid > 0
            let s:building_repos[jobid . ''] = a:repo
            call s:msg_on_build_start(a:repo.name)
        elseif jobid == 0
            call s:msg_on_build_failed(a:repo.name)
        elseif jobid == -1
            if type(argv) == type([])
                call s:msg_on_build_failed(a:repo.name, argv[0] . ' is not executable')
            else
                call s:msg_on_build_failed(a:repo.name)
            endif
        endif
    else
        let s:building_repos[s:jobpid] = a:repo
        call s:msg_on_build_start(a:repo.name)
        redraw!
        call s:JOB.start(argv,{
                    \ 'on_exit' : function('s:on_build_exit'),
                    \ 'cwd' : a:repo.path,
                    \ })

    endif
endfunction

function! s:msg_on_build_start(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3,
                \ '* ' . a:name . ': Building ')
endfunction

function! s:get_build_argv(build) abort
    " TODO check os
    return a:build
endfunction
" + foo.vim: Updating...
if has('nvim')
    function! s:msg_on_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
    function! s:msg_on_install_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
    endfunction
elseif has('python')
    function! s:msg_on_start(name) abort
        call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
    function! s:msg_on_install_start(name) abort
        call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
    endfunction
else
    function! s:msg_on_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
    function! s:msg_on_install_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Installing...')
    endfunction
endif

" - foo.vim: Updating done.
function! s:msg_on_updated_done(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Updating done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_updated_failed(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Updating failed.')
endfunction

function! s:msg_on_install_process(name, status) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3,
                \ '* ' . a:name . ': Installing ' . a:status)
endfunction

" - foo.vim: Updating done.
function! s:msg_on_install_done(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Installing done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_install_failed(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Installing failed.')
endfunction

" - foo.vim: Updating done.
function! s:msg_on_build_done(name) abort
    call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '- ' . a:name . ': Building done.')
endfunction

" - foo.vim: Updating failed.
function! s:msg_on_build_failed(name, ...) abort
    if a:0 == 1
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Building failed, ' . a:1)
    else
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, 'x ' . a:name . ': Building failed.')
    endif
endfunction

function! s:new_window() abort
    if s:plugin_manager_buffer != 0 && bufexists(s:plugin_manager_buffer)
        " buffer exist, process has not finished!
        return 0
    elseif s:plugin_manager_buffer != 0 && !bufexists(s:plugin_manager_buffer)
        " buffer is hidden, process has not finished!
        call s:resume_window()
        return 1
    else
        execute get(g:, 'spacevim_window', 'vertical topleft new')
        let s:plugin_manager_buffer = bufnr('%')
        setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
        setf SpaceVimPlugManager
        nnoremap <silent> <buffer> q :bd<CR>
        " process has finished or does not start.
        return 2
    endif
endfunction

function! s:resume_window() abort
    execute get(g:, 'spacevim_window', 'vertical topleft new')
    let s:plugin_manager_buffer = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell
    setf SpaceVimPlugManager
    nnoremap <silent> <buffer> q :bd<CR>
    call setline(1, s:plugin_manager_buffer_lines)
    setlocal nomodifiable 
endfunction

" change modifiable before setline
if has('nvim') && exists('*nvim_buf_set_lines')
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        if bufexists(s:plugin_manager_buffer)
            call nvim_buf_set_lines(a:bufnr, a:nr - 1, a:nr, 0, [a:line])
        endif
        if len(s:plugin_manager_buffer_lines) >= a:nr
            let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
        else
            call add(s:plugin_manager_buffer_lines, a:line)
        endif
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
        if bufexists(s:plugin_manager_buffer)
            py bufnr = string.atoi(vim.eval("a:bufnr"))
            py linr = string.atoi(vim.eval("a:nr")) - 1
            py str = vim.eval("a:line")
            py vim.buffers[bufnr][linr] = str
        endif
        if len(s:plugin_manager_buffer_lines) >= a:nr
            let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
        else
            call add(s:plugin_manager_buffer_lines, a:line)
        endif
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction

    function! s:append_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        if bufexists(s:plugin_manager_buffer)
            py bufnr = string.atoi(vim.eval("a:bufnr"))
            py linr = string.atoi(vim.eval("a:nr")) - 1
            py str = vim.eval("a:line")
            py vim.buffers[bufnr].append(str)
        endif
        call add(s:plugin_manager_buffer_lines, a:line)
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
    " @vimlint(EVL103, 0, a:bufnr)
    " @vimlint(EVL103, 0, a:nr)
    " @vimlint(EVL103, 0, a:line)
else
    function! s:focus_main_win() abort
        let winnr = bufwinnr(s:plugin_manager_buffer)
        if winnr > -1
            exe winnr . 'wincmd w'
        endif
        return winnr
    endfunction
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(a:bufnr,'&ma', 1)
        if bufexists(s:plugin_manager_buffer)
            if s:focus_main_win() >= 0
                call setline(a:nr, a:line)
            endif
        endif
        if len(s:plugin_manager_buffer_lines) >= a:nr
            let s:plugin_manager_buffer_lines[a:nr - 1] = a:line
        else
            call add(s:plugin_manager_buffer_lines, a:line)
        endif
        call setbufvar(a:bufnr,'&ma', 0)
    endfunction
endif
