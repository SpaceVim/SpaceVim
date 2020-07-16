"=============================================================================
" statusline.vim --- SpaceVim statusline API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}
if has('nvim')
  let s:self.__floating = SpaceVim#api#import('neovim#floating')
else
  let s:self.__floating = SpaceVim#api#import('vim#floating')
endif
let s:self.__buffer = SpaceVim#api#import('vim#buffer')
let s:self.__cmp = SpaceVim#api#import('vim#compatible')


function! s:self.check_width(len, sec, winwidth) abort
  return a:len + self.len(a:sec) < a:winwidth
endfunction

function! s:self.len(sec) abort
  let str = matchstr(a:sec, '%{.*}')
  if !empty(str)
    return len(a:sec) - len(str) + len(eval(str[2:-2])) + 4
  else
    return len(a:sec) + 4
  endif
endfunction

function! s:self.eval(sec) abort
  return substitute(a:sec, '%{.*}', '', 'g')
endfunction

function! s:self.build(left_sections, right_sections, lsep, rsep, fname, tag, hi_a, hi_b, hi_c, hi_z, winwidth) abort
  let l = '%#' . a:hi_a . '#' . a:left_sections[0]
  let l .= '%#' . a:hi_a . '_' . a:hi_b . '#' . a:lsep
  let flag = 1
  let len = 0
  for sec in filter(a:left_sections[1:], '!empty(v:val)')
    if self.check_width(len, sec, a:winwidth)
      let len += self.len(sec)
      if flag == 1
        let l .= '%#' . a:hi_b . '#' . sec
        let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:lsep
      else
        let l .= '%#' . a:hi_c . '#' . sec
        let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:lsep
      endif
      let flag = flag * -1
    endif
  endfor
  let l = l[:len(a:lsep) * -1 - 1]
  if empty(a:right_sections)
    if flag == 1
      return l . '%#' . a:hi_c . '#'
    else
      return l . '%#' . a:hi_b . '#'
    endif
  endif
  if self.check_width(len, a:fname, a:winwidth)
    let len += self.len(a:fname)
    if flag == 1
      let l .= '%#' . a:hi_c . '_' . a:hi_z . '#' . a:lsep . '%#' . a:hi_z . '#' . a:fname . '%='
    else
      let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:lsep . '%#' . a:hi_z . '#' . a:fname . '%='
    endif
  else
    if flag == 1
      let l .= '%#' . a:hi_c . '_' . a:hi_z . '#' . a:lsep . '%='
    else
      let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:lsep . '%='
    endif
  endif
  if self.check_width(len, a:tag, a:winwidth) && g:spacevim_enable_statusline_tag
    let l .= '%#' . a:hi_z . '#' . a:tag
  endif
  let l .= '%#' . a:hi_b . '_' . a:hi_z . '#' . a:rsep
  let flag = 1
  for sec in filter(a:right_sections, '!empty(v:val)')
    if self.check_width(len, sec, a:winwidth)
      let len += self.len(sec)
      if flag == 1
        let l .= '%#' . a:hi_b . '#' . sec
        let l .= '%#' . a:hi_c . '_' . a:hi_b . '#' . a:rsep
      else
        let l .= '%#' . a:hi_c . '#' . sec
        let l .= '%#' . a:hi_b . '_' . a:hi_c . '#' . a:rsep
      endif
      let flag = flag * -1
    endif
  endfor
  return l[:-4]
endfunction

function! s:self.support_float() abort
  return self.__floating.exists()
endfunction

function! s:self.open_float(st) abort
  if !has_key(self, '__bufnr') || !bufexists(self.__bufnr)
    let self.__bufnr = self.__buffer.bufadd('')
  endif
  if has_key(self, '__winid') && win_id2tabwin(self.__winid)[0] == tabpagenr()
  else
    let self.__winid = self.__floating.open_win(self.__bufnr,
          \ v:false,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : &columns,
          \ 'height'  : 1,
          \ 'highlight' : 'SpaceVim_statusline_a_bold',
          \ 'row': &lines - 2 ,
          \ 'col': 0
          \ })
  endif
  call setbufvar(self.__bufnr, '&relativenumber', 0)
  call setbufvar(self.__bufnr, '&number', 0)
  call setbufvar(self.__bufnr, '&bufhidden', 'wipe')
  call setbufvar(self.__bufnr, '&cursorline', 0)
  call setbufvar(self.__bufnr, '&modifiable', 1)
  if exists('*nvim_buf_set_virtual_text')
    call setwinvar(win_id2win(self.__winid), '&cursorline', 0)
    call nvim_buf_set_virtual_text(
          \ self.__bufnr,
          \ -1,
          \ 0,
          \ a:st,
          \ {})
  else
    let l = ''
    for [str, hg] in a:st
      let l .= str
    endfor
    call self.__buffer.buf_set_lines(self.__bufnr, 0, -1, 0, [l])
    let begin = 1
    let end = 0
    for [str, hg] in a:st
      let end = strlen(str)
      call win_execute(self.__winid, 'call self.__cmp.matchaddpos(hg, [[1, begin, end]])')
      let begin += end
    endfor
  endif
  call setbufvar(self.__bufnr, '&modifiable', 0)
  redraw!
endfunction

if s:self.__floating.exists()
  function! s:self.close_float() abort
    call self.__floating.win_close(self.__winid, 1)
  endfunction
else
  function! s:self.close_float() abort
    if has_key(self, '__winid') && win_id2tabwin(self.__winid)[0] == tabpagenr()
      noautocmd execute win_id2win(self.__winid).'wincmd w'
      noautocmd close
    endif
  endfunction
endif
function! SpaceVim#api#vim#statusline#get() abort
  return deepcopy(s:self)
endfunction

" vim:set et sw=2 cc=80 nowrap:
