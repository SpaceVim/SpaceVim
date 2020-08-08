"=============================================================================
" tab.vim --- SpaceVim tab API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
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

function! s:self.previous_tabpagenr() abort
  let tabsinfo = self.__cmp.execute('tabs')
  let number = 0
  for line in split(tabsinfo, "\n")
    if line =~# '^Tab page \d'
      let number = str2nr(matchstr(line, '\d\+'))
    elseif line =~# '^#'
      return number
    endif
  endfor
endfunction

function! SpaceVim#api#vim#tab#get() abort
  return deepcopy(s:self)
endfunction
