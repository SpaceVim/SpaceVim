" ============================================================================
" File:        autoload/gitstatus/job.vim
" Description: git status indicator syntax highlighting
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if !get(g:, 'NERDTreeGitStatusEnable', 0)
    finish
endif

function! s:getIndicator(status) abort
    return gitstatus#getIndicator(a:status)
endfunction

if gitstatus#shouldConceal()
    " Hide the backets
    syntax match hideBracketsInNerdTreeL "\]" contained conceal containedin=NERDTreeFlags
    syntax match hideBracketsInNerdTreeR "\[" contained conceal containedin=NERDTreeFlags
    setlocal conceallevel=3
    setlocal concealcursor=nvic
endif

function! s:highlightFromGroup(group) abort
    let l:synid = synIDtrans(hlID(a:group))
    let [l:ctermfg, l:guifg] = [synIDattr(l:synid, 'fg', 'cterm'), synIDattr(l:synid, 'fg', 'gui')]
    return 'cterm=NONE ctermfg=' . l:ctermfg . ' ctermbg=NONE gui=NONE guifg=' . l:guifg . ' guibg=NONE'
endfunction

function! s:setHightlighting() abort
    let l:synlist = [
                \ ['Unmerged',  'Function'],
                \ ['Modified',  'Special'],
                \ ['Staged',    'Function'],
                \ ['Renamed',   'Title'],
                \ ['Unmerged',  'Label'],
                \ ['Untracked', 'Comment'],
                \ ['Dirty',     'Tag'],
                \ ['Deleted',   'Operator'],
                \ ['Ignored',   'SpecialKey'],
                \ ['Clean',     'Method'],
                \ ]

    for [l:name, l:group] in l:synlist
        let l:indicator = escape(s:getIndicator(l:name), '\#-*.$')
        let l:synname = 'NERDTreeGitStatus' . l:name
        execute 'silent! syntax match ' . l:synname . ' #\m\C\zs[' . l:indicator . ']\ze[^\]]*\]# containedin=NERDTreeFlags'
        let l:hipat = get(get(g:, 'NERDTreeGitStatusHighlightingCustom', {}),
                    \ l:name,
                    \ s:highlightFromGroup(l:group))
        execute 'silent! highlight ' . l:synname . ' ' . l:hipat
    endfor
endfunction

silent! call s:setHightlighting()
