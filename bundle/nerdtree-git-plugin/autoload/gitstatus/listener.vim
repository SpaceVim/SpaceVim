" ============================================================================
" File:        autoload/gitstatus/listener.vim
" Description: nerdtree event listener
" Maintainer:  Xuyuan Pang <xuyuanp at gmail dot com>
" License:     This program is free software. It comes without any warranty,
"              to the extent permitted by applicable law. You can redistribute
"              it and/or modify it under the terms of the Do What The Fuck You
"              Want To Public License, Version 2, as published by Sam Hocevar.
"              See http://sam.zoy.org/wtfpl/COPYING for more details.
" ============================================================================
if exists('g:loaded_nerdtree_git_status_listener')
    finish
endif
let g:loaded_nerdtree_git_status_listener = 1

let s:Listener = {
            \ 'current': {},
            \ 'next': {},
            \ }

" disabled ProhibitImplicitScopeVariable because we will use lots of `self`
" vint: -ProhibitImplicitScopeVariable
function! s:Listener.OnInit(event) abort
    call self.callback(a:event)
endfunction

function! s:Listener.OnRefresh(event) abort
    call self.callback(a:event)
endfunction

function! s:Listener.OnRefreshFlags(event) abort
    call self.callback(a:event)
endfunction

function! s:Listener.callback(event) abort
    let l:path = a:event.subject
    let l:indicator = self.getIndicatorByPath(l:path)
    call l:path.flagSet.clearFlags('git')
    if l:indicator !=# ''
        if gitstatus#shouldConceal()
            let l:indicator = printf(' %s ', l:indicator)
        endif
        call l:path.flagSet.addFlag('git', l:indicator)
    endif
endfunction

function!s:Listener.getIndicatorByPath(path) abort
    let l:pathStr = gitstatus#util#FormatPath(a:path)
    let l:statusKey = get(self.current, l:pathStr, '')

    if l:statusKey !=# ''
        return gitstatus#getIndicator(l:statusKey)
    endif

    if self.getOption('ShowClean', 0)
        return gitstatus#getIndicator('Clean')
    endif

    if self.getOption('ConcealBrackets', 0) && self.getOption('AlignIfConceal', 0)
        return ' '
    endif
    return ''
endfunction

function! s:Listener.SetNext(cache) abort
    let self.next = a:cache
endfunction

function! s:Listener.HasPath(path_str) abort
    return has_key(self.current, a:path_str)
endfunction

function! s:Listener.changed() abort
    return self.current !=# self.next
endfunction

function! s:Listener.update() abort
    let self.current = self.next
endfunction

function! s:Listener.TryUpdateNERDTreeUI() abort
    if !g:NERDTree.IsOpen()
        return
    endif

    if !self.changed()
        return
    endif

    call self.update()

    let l:winnr = winnr()
    let l:altwinnr = winnr('#')

    try
        call g:NERDTree.CursorToTreeWin()
        call b:NERDTree.root.refreshFlags()
        call NERDTreeRender()
    finally
        noautocmd exec l:altwinnr . 'wincmd w'
        noautocmd exec l:winnr . 'wincmd w'
    endtry
endfunction

function! s:Listener.getOption(name, default) abort
    return get(self.opts, 'NERDTreeGitStatus' . a:name, a:default)
endfunction
" vint: +ProhibitImplicitScopeVariable

function! gitstatus#listener#New(opts) abort
    return extend(deepcopy(s:Listener), {'opts': a:opts})
endfunction
