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
" key : plugin name, value : buf line number in manager buffer.
let s:ui_buf = {}

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

function! SpaceVim#plugins#manager#install(...) abort
endfunction

" @vimlint(EVL102, 1, l:i)
function! SpaceVim#plugins#manager#update(...) abort
    call s:new_window()
    let s:plugin_manager_buffer = bufnr('%')
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nomodifiable nospell
    setf spacevim
    if exists('g:syntax_on')
        call s:syntax()
    endif
    nnoremap <silent> <buffer> q :bd<CR>
    let s:pct = 0
    let s:plugins = a:0 == 0 ? keys(dein#get()) : copy(a:1)
    let s:total = len(s:plugins)
    call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updating plugins (' . s:pct . '/' . s:total . ')')
    if has('nvim')
        call s:set_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:set_buf_line(s:plugin_manager_buffer, 3, '')
    else
        call s:append_buf_line(s:plugin_manager_buffer, 2, s:status_bar())
        call s:append_buf_line(s:plugin_manager_buffer, 3, '')
    endif
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
        call s:set_buf_line(s:plugin_manager_buffer, 1, 'Updated. Elapsed time:')
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
" + foo.vim: Updating...
if has('nvim')
    function! s:msg_on_start(name) abort
        call s:set_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
    endfunction
else
    function! s:msg_on_start(name) abort
        call s:append_buf_line(s:plugin_manager_buffer, s:ui_buf[a:name] + 3, '+ ' . a:name . ': Updating...')
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

function! s:new_window() abort
    execute get(g:, 'spacevim_window', 'vertical topleft new')
endfunction

function! s:syntax() abort
    syntax clear
    syntax region plug1 start=/\%1l/ end=/\%2l/ contains=plugNumber
    syntax region plug2 start=/\%2l/ end=/\%3l/ contains=plugBracket,plugX
    syn match plugNumber /[0-9]\+[0-9.]*/ contained
    syn match plugBracket /[[\]]/ contained
    syn match plugX /x/ contained
    syn match plugDash /^-/
    syn match plugPlus /^+/
    syn match plugStar /^*/
    syn match plugMessage /\(^- \)\@<=.*/
    syn match plugName /\(^- \)\@<=[^ ]*:/
    syn match plugSha /\%(: \)\@<=[0-9a-f]\{4,}$/
    syn match plugTag /(tag: [^)]\+)/
    syn match plugInstall /\(^+ \)\@<=[^:]*/
    syn match plugUpdate /\(^* \)\@<=[^:]*/
    syn match plugCommit /^  \X*[0-9a-f]\{7,9} .*/ contains=plugRelDate,plugEdge,plugTag
    syn match plugEdge /^  \X\+$/
    syn match plugEdge /^  \X*/ contained nextgroup=plugSha
    syn match plugSha /[0-9a-f]\{7,9}/ contained
    syn match plugRelDate /([^)]*)$/ contained
    syn match plugNotLoaded /(not loaded)$/
    syn match plugError /^x.*/
    syn region plugDeleted start=/^\~ .*/ end=/^\ze\S/
    syn match plugH2 /^.*:\n-\+$/
    syn keyword Function PlugInstall PlugStatus PlugUpdate PlugClean
    hi def link plug1       Title
    hi def link plug2       Repeat
    hi def link plugH2      Type
    hi def link plugX       Exception
    hi def link plugBracket Structure
    hi def link plugNumber  Number

    hi def link plugDash    Special
    hi def link plugPlus    Constant
    hi def link plugStar    Boolean

    hi def link plugMessage Function
    hi def link plugName    Label
    hi def link plugInstall Function
    hi def link plugUpdate  Type

    hi def link plugError   Error
    hi def link plugDeleted Ignore
    hi def link plugRelDate Comment
    hi def link plugEdge    PreProc
    hi def link plugSha     Identifier
    hi def link plugTag     Constant

    hi def link plugNotLoaded Comment
endfunction

" change modifiable before setline
if has('nvim')
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        call nvim_buf_set_lines(a:bufnr, a:nr - 1, a:nr, 0, [a:line])
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
else
    py import vim
    py import string
    function! s:set_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        py bufnr = string.atoi(vim.eval("a:bufnr"))
        py linr = string.atoi(vim.eval("a:nr")) - 1
        py str = vim.eval("a:line")
        py vim.buffers[bufnr][linr] = str
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction

    function! s:append_buf_line(bufnr, nr, line) abort
        call setbufvar(s:plugin_manager_buffer,'&ma', 1)
        py bufnr = string.atoi(vim.eval("a:bufnr"))
        py linr = string.atoi(vim.eval("a:nr")) - 1
        py str = vim.eval("a:line")
        py vim.buffers[bufnr].append(str)
        call setbufvar(s:plugin_manager_buffer,'&ma', 0)
    endfunction
endif
