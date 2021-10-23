" ============================================================================
" File:        autoload/gitstatus.vim
" Description: library for indicators
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status_autoload')
    finish
endif
let g:loaded_nerdtree_git_status_autoload = 1

function! gitstatus#isWin() abort
    return has('win16') || has('win32') || has('win64')
endfunction

if get(g:, 'NERDTreeGitStatusUseNerdFonts', 0)
    let s:indicatorMap = {
                \ 'Modified'  :nr2char(61545),
                \ 'Staged'    :nr2char(61543),
                \ 'Untracked' :nr2char(61736),
                \ 'Renamed'   :nr2char(62804),
                \ 'Unmerged'  :nr2char(61556),
                \ 'Deleted'   :nr2char(63167),
                \ 'Dirty'     :nr2char(61453),
                \ 'Ignored'   :nr2char(61738),
                \ 'Clean'     :nr2char(61452),
                \ 'Unknown'   :nr2char(61832)
                \ }
elseif &encoding ==? 'utf-8'
    let s:indicatorMap = {
                \ 'Modified'  :nr2char(10041),
                \ 'Staged'    :nr2char(10010),
                \ 'Untracked' :nr2char(10029),
                \ 'Renamed'   :nr2char(10140),
                \ 'Unmerged'  :nr2char(9552),
                \ 'Deleted'   :nr2char(10006),
                \ 'Dirty'     :nr2char(10007),
                \ 'Ignored'   :nr2char(33),
                \ 'Clean'     :nr2char(10004),
                \ 'Unknown'   :nr2char(120744)
                \ }
else
    let s:indicatorMap = {
                \ 'Modified'  :'*',
                \ 'Staged'    :'+',
                \ 'Untracked' :'!',
                \ 'Renamed'   :'R',
                \ 'Unmerged'  :'=',
                \ 'Deleted'   :'D',
                \ 'Dirty'     :'X',
                \ 'Ignored'   :'?',
                \ 'Clean'     :'C',
                \ 'Unknown'   :'E'
                \ }
endif

function! gitstatus#getIndicator(status) abort
    return get(get(g:, 'NERDTreeGitStatusIndicatorMapCustom', {}),
                \ a:status,
                \ s:indicatorMap[a:status])
endfunction

function! gitstatus#shouldConceal() abort
    return has('conceal') && g:NERDTreeGitStatusConcealBrackets
endfunction
