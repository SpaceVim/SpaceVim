"=============================================================================
" cheat.vim --- cheat plugin
" Copyright (c) 2016-2023 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

function! s:_update_git() abort
    echom "Update git"
    let tips = eval(join(systemlist('curl -s https://raw.githubusercontent.com/git-tips/tips/master/tips.json')))

    let t = ''
    for tip in tips
        let t = t . "###" . tip.title . "\n"
        let t = t . "```\n" . tip.tip . "\n```\n\n"
    endfor

    call writefile(split(t,"\n"), g:cheats_dir . 'git.md')
endfunction

function! cheat#Update(cheatName) abort
    if exists("*s:_update_" . a:cheatName)
        exec "call s:_update_" . a:cheatName ."()"
    else
        echohl WarningMsg | echom "Has no upstream for " . a:cheatName | echohl None
    endif
endfunction

function! cheat#List_sheets() abort
    return map(split(globpath(g:cheats_dir, '*'),'\n'), "fnamemodify(v:val, ':t')")
endfunction
