" ============================================================================
" File:        autoload/gitstatus/job.vim
" Description: leveled-logger
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status_log')
    finish
endif
let g:loaded_nerdtree_git_status_log = 1

let s:debug   = 0 | :lockvar s:debug
let s:info    = 1 | :lockvar s:info
let s:warning = 2 | :lockvar s:warning
let s:error   = 3 | :lockvar s:error

let s:Logger = {}

" vint: -ProhibitImplicitScopeVariable
function! s:Logger.output(level, msg) abort
    if a:level < self.level
        return
    endif
    echomsg '[nerdtree-git-status] ' . a:msg
endfunction

function! s:Logger.debug(msg) abort
    echohl LineNr |
                \ call self.output(s:debug, a:msg) |
                \ echohl None
endfunction

function! s:Logger.info(msg) abort
    call self.output(s:info, a:msg)
endfunction

function! s:Logger.warning(msg) abort
    echohl WarningMsg |
                \ call self.output(s:warning, a:msg) |
                \ echohl None
endfunction

function! s:Logger.error(msg) abort
    echohl ErrorMsg |
                \ call self.output(s:error, a:msg) |
                \ echohl None
endfunction
" vint: +ProhibitImplicitScopeVariable

function! gitstatus#log#NewLogger(level) abort
    return extend(copy(s:Logger), {'level': a:level})
endfunction
