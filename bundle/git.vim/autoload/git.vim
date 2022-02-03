"=============================================================================
" git.vim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section Introduction, intro
" @library
" @order intro options config layers api faq changelog
" git.vim is a simple plugin for using git in vim and neovim.
" This plugin requires SpaceVim API and |job| support.

function! git#run(...) abort
    let cmd = get(a:000, 0, '')
    if cmd ==# 'add'
        call git#add#run(a:000[1:])
    elseif cmd ==# 'push'
        call git#push#run(a:000[1:])
    elseif cmd ==# 'pull'
        call git#pull#run(a:000[1:])
    elseif cmd ==# 'status'
        call git#status#run(a:000[1:])
    elseif cmd ==# 'stash'
        call git#stash#run(a:000[1:])
    elseif cmd ==# 'config'
        call git#config#run(a:000[1:])
    elseif cmd ==# 'diff'
        call git#diff#run(a:000[1:])
    elseif cmd ==# 'rm'
        call git#rm#run(a:000[1:])
    elseif cmd ==# 'mv'
        call git#mv#run(a:000[1:])
    elseif cmd ==# 'log'
        call git#log#run(a:000[1:])
    elseif cmd ==# 'reflog'
        call git#reflog#run(a:000[1:])
    elseif cmd ==# 'reset'
        call git#reset#run(a:000[1:])
    elseif cmd ==# 'merge'
        call git#merge#run(a:000[1:])
    elseif cmd ==# 'blame'
        call git#blame#run(a:000[1:])
    elseif cmd ==# 'rebase'
        call git#rebase#run(a:000[1:])
    elseif cmd ==# 'remote'
        call git#remote#run(a:000[1:])
    elseif cmd ==# 'fetch'
        call git#fetch#run(a:000[1:])
    elseif cmd ==# 'commit'
        call git#commit#run(a:000[1:])
    elseif cmd ==# 'branch'
        call git#branch#run(a:000[1:])
    elseif cmd ==# 'checkout'
        call git#checkout#run(a:000[1:])
    elseif cmd ==# 'cherry-pick'
        call git#cherry_pick#run(a:000[1:])
    elseif cmd ==# '--log'
        let args = get(a:000, 1, '')
        if args ==# 'clear'
            call git#logger#clear()
        else
            call git#logger#view()
        endif
    else
        echohl WarningMsg
        echo 'Git ' . cmd . ' has not been implemented!'
        echohl None
    endif
endfunction


function! git#complete(ArgLead, CmdLine, CursorPos) abort
    let str = a:CmdLine[:a:CursorPos-1]
    if str =~# '^Git\s\+[a-zA-Z]*$'
        return join(['add', 'push', 'status', 'commit', 'diff',
                    \ 'merge', 'rebase', 'branch', 'checkout',
                    \ 'fetch', 'reset', 'log', 'config', 'reflog',
                    \ 'blame', 'pull', 'stash', 'cherry-pick', 'rm', 'mv', 'remote'
                    \ ],
                    \ "\n")
    elseif str =~# '^Git\s\+add\s\+.*$'
        return git#add#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+rm\s\+.*$'
        return git#rm#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+remote\s\+.*$'
        return git#remote#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+mv\s\+.*$'
        return git#mv#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+push\s\+.*$'
        return git#push#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+diff\s\+.*$'
        return git#diff#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+blame\s\+.*$'
        return git#blame#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+merge\s\+.*$'
        return git#merge#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+log\s\+.*$'
        return git#log#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+branch\s\+.*$'
        return git#branch#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+checkout\s\+.*$'
        return git#checkout#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+fetch\s\+.*$'
        return git#fetch#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+stash\s\+.*$'
        return git#stash#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+config\s\+.*$'
        return git#config#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    elseif str =~# '^Git\s\+reflog\s\+.*$'
        return git#reflog#complete(a:ArgLead, a:CmdLine, a:CursorPos)
    else
        return ''
    endif
endfunction
