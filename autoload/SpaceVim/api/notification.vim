"=============================================================================
" notification.vim --- notification api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Global values, this can be used between different notification

let s:messages = []

let s:shown = []

let s:self = {}

let s:self.winid = -1
let s:self.bufnr = -1
let s:self.border = {}
let s:self.border.winid = -1
let s:self.border.bufnr = -1
let s:self.borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let s:self.title = ''
let s:self.win_is_open = 0
let s:self.timeout = 3000

if has('nvim')
  let s:self.__floating = SpaceVim#api#import('neovim#floating')
else
  let s:self.__floating = SpaceVim#api#import('vim#floating')
endif
let s:self.__buffer = SpaceVim#api#import('vim#buffer')

function! s:self.draw_border(title, width, height) abort
  let top = self.borderchars[4] .
        \ repeat(self.borderchars[0], a:width) .
        \ self.borderchars[5]
  let mid = self.borderchars[3] .
        \ repeat(' ', a:width) .
        \ self.borderchars[1]
  let bot = self.borderchars[7] .
        \ repeat(self.borderchars[2], a:width) .
        \ self.borderchars[6]
  let top = self.string_compose(top, 1, a:title)
  let lines = [top] + repeat([mid], a:height) + [bot]
  return lines
endfunction

function! s:self.string_compose(target, pos, source)
  if a:source == ''
    return a:target
  endif
  let pos = a:pos
  let source = a:source
  if pos < 0
    let source = strcharpart(a:source, -pos)
    let pos = 0
  endif
  let target = strcharpart(a:target, 0, pos)
  if strchars(target) < pos
    let target .= repeat(' ', pos - strchars(target))
  endif
  let target .= source
  " vim popup will pad the end of title but not begin part
  " so we build the title as ' floaterm idx/cnt'
  " therefore, we need to add a space here
  let target .= ' ' . strcharpart(a:target, pos + strchars(source) + 1)
  return target
endfunction


let s:timer_id = -1

function! s:self.close(...) dict
  if len(s:shown) == 1
    noautocmd call self.__floating.win_close(self.border.winid, v:true)
    noautocmd call self.__floating.win_close(self.winid, v:true)
    let self.win_is_open = v:false
  endif
  if !empty(s:shown)
    call add(s:messages, remove(s:shown, 0))
  endif
endfunction

function! s:self.notification(msg, color) abort
  call add(s:shown, a:msg)
  if !bufexists(self.border.bufnr)
    let self.border.bufnr = self.__buffer.create_buf(0, 0)
  endif
  if !bufexists(self.bufnr)
    let self.bufnr = self.__buffer.create_buf(0, 0)
  endif
  call self.__buffer.buf_set_lines(self.border.bufnr, 0 , -1, 0, self.draw_border(self.title, strwidth(a:msg) + 1, 1 + len(s:shown) + 2))
  if self.win_is_open
    call self.__floating.win_config(self.border.winid,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : strwidth(a:msg) + 1, 
          \ 'height'  : 1 + len(s:shown) + 2,
          \ 'row': 2,
          \ 'col': &columns - strwidth(a:msg) - 3,
          \ })
    call self.__floating.win_config(self.winid,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : strwidth(a:msg), 
          \ 'height'  : 1 + len(s:shown),
          \ 'row': 3,
          \ 'highlight' : a:color,
          \ 'col': &columns - strwidth(a:msg) - 3,
          \ })
  else
    let self.winid =  self.__floating.open_win(self.bufnr, v:false,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : strwidth(a:msg), 
          \ 'height'  : 1 + len(s:shown),
          \ 'row': 2,
          \ 'highlight' : a:color,
          \ 'col': &columns - strwidth(a:msg) - 3
          \ })
    let self.border.winid =  self.__floating.open_win(self.border.bufnr, v:false,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : strwidth(a:msg) + 1, 
          \ 'height'  : 1 + len(s:shown) + 2,
          \ 'row': 3,
          \ 'col': &columns - strwidth(a:msg) - 3,
          \ })
    let self.win_is_open = v:true
  endif
  call self.__buffer.buf_set_lines(self.bufnr, 0 , -1, 0, s:shown)
  if exists('&winhighlight')
    call setbufvar(self.bufnr, '&winhighlight', 'Normal:Pmenu')
    call setbufvar(self.border.bufnr, '&winhighlight', 'Normal:Pmenu')
  endif
  call setbufvar(self.bufnr, '&number', 0)
  call setbufvar(self.bufnr, '&relativenumber', 0)
  call setbufvar(self.bufnr, '&buftype', 'nofile')
  call setbufvar(self.border.bufnr, '&number', 0)
  call setbufvar(self.border.bufnr, '&relativenumber', 0)
  call setbufvar(self.border.bufnr, '&buftype', 'nofile')
  call timer_start(self.timeout, self.close, {'repeat' : 1})
endfunction


function! SpaceVim#api#notification#get()

  return deepcopy(s:self)

endfunction

