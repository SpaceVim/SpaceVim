"=============================================================================
" tab.vim --- SpaceVim tab API
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

let s:self._tree = {}

function! s:self._update() abort
    let tabnr = tabpagenr('$')
    let self._tree = {}
    for i in range(1, tabnr)
        let buffers = tabpagebuflist(i)
        let self._tree[i] = buffers
    endfor
endfunction

function! s:self._jump(tabnr, bufid) abort
    exe 'tabnext' . a:tabnr
    if index(tabpagebuflist(a:tabnr), a:bufid) != -1
        let winnr = bufwinnr(bufname(a:bufid))
        exe winnr .  'wincmd w'
    endif
endfunction

function! s:self.get_tree() abort
    call self._update()
    return self._tree
endfunction

function! s:self.realTabBuffers(id) abort
    return filter(copy(tabpagebuflist(a:id)), 'buflisted(v:val) && getbufvar(v:val, "&buftype") == ""')
endfunction

function! SpaceVim#api#vim#tab#get() abort
    return deepcopy(s:self)
endfunction
