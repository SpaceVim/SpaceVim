"=============================================================================
" tab.vim --- SpaceVim tab API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}
let s:self.__cmp = SpaceVim#api#import('vim#compatible')

let s:self._tree = {}

function! s:self._update() abort
  let tabnr = tabpagenr('$')
  let self._tree = {}
  for i in range(1, tabnr)
    let buffers = tabpagebuflist(i)
    let self._tree[i] = buffers
  endfor
endfunction

function! s:self._jump(tabnr, winid) abort
  exe 'tabnext' . a:tabnr
  exe a:winid .  'wincmd w'
endfunction

function! s:self.get_tree() abort
  call self._update()
  return self._tree
endfunction

function! s:self.realTabBuffers(id) abort
  return filter(copy(tabpagebuflist(a:id)), 'buflisted(v:val) && getbufvar(v:val, "&buftype") ==# ""')
endfunction

function! s:tab_closed_handle() abort
  if expand('<afile>') <= get(s:, 'previous_tabpagenr', 0)
    let s:previous_tabpagenr -= 1
  endif
endfunction

" as vim do not support tabpagenr('#')
augroup spacevim_api_vim_tab
  autocmd!
  autocmd TabLeave * let s:previous_tabpagenr = tabpagenr()
  if exists('##TabClosed')
    autocmd TabClosed * call <SID>tab_closed_handle()
  endif
augroup END

function! s:self.previous_tabpagenr() abort
  return get(s:, 'previous_tabpagenr', 0)
endfunction

function! SpaceVim#api#vim#tab#get() abort
  return deepcopy(s:self)
endfunction
