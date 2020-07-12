"=============================================================================
" notification.vim --- notification api
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Global values, this can be used between different notification

let s:notifications = {}

" dictionary values and functions

let s:self = {}
let s:self.message = []
let s:self.winid = -1
let s:self.bufnr = -1
let s:self.border = {}
let s:self.border.winid = -1
let s:self.border.bufnr = -1
let s:self.borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let s:self.title = ''
let s:self.win_is_open = 0
let s:self.timeout = 3000
let s:self.hashkey = ''

if has('nvim')
  let s:self.__floating = SpaceVim#api#import('neovim#floating')
else
  let s:self.__floating = SpaceVim#api#import('vim#floating')
endif
let s:self.__buffer = SpaceVim#api#import('vim#buffer')
let s:self.__password = SpaceVim#api#import('password')

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


function! s:self.close(...) dict
  if !empty(self.message)
    call remove(self.message, 0)
    let self.notification_width = max(map(deepcopy(self.message), 'strwidth(v:val)'))
  endif
  if len(self.message) == 0
    noautocmd call self.__floating.win_close(self.border.winid, v:true)
    noautocmd call self.__floating.win_close(self.winid, v:true)
    call remove(s:notifications, self.hashkey)
    let self.win_is_open = v:false
  endif
  for hashkey in keys(s:notifications)
      call s:notifications[hashkey].redraw_windows()
  endfor
endfunction

function! s:self.notification(msg, color) abort
  call add(self.message, a:msg)
  let self.notification_color = a:color
  if !bufexists(self.border.bufnr)
    let self.border.bufnr = self.__buffer.create_buf(0, 0)
  endif
  if !bufexists(self.bufnr)
    let self.bufnr = self.__buffer.create_buf(0, 0)
  endif
  if empty(self.hashkey)
    let self.hashkey = self.__password.generate_simple(10)
  endif
  call self.redraw_windows()
  call setbufvar(self.bufnr, '&number', 0)
  call setbufvar(self.bufnr, '&relativenumber', 0)
  call setbufvar(self.bufnr, '&buftype', 'nofile')
  call setbufvar(self.border.bufnr, '&number', 0)
  call setbufvar(self.border.bufnr, '&relativenumber', 0)
  call setbufvar(self.border.bufnr, '&buftype', 'nofile')
  call extend(s:notifications, {self.hashkey : self})
  call timer_start(self.timeout, self.close, {'repeat' : 1})
endfunction

function! s:self.redraw_windows() abort
  if empty(self.message)
    return
  endif
  let self.notification_width = max(map(deepcopy(self.message), 'strwidth(v:val)'))
  call self.__buffer.buf_set_lines(self.border.bufnr, 0 , -1, 0, self.draw_border(self.title, self.notification_width, len(self.message)))
  call self.__buffer.buf_set_lines(self.bufnr, 0 , -1, 0, self.message)
  let self.begin_row = 2
  for hashkey in keys(s:notifications)
    if hashkey !=# self.hashkey
      let self.begin_row += len(s:notifications[hashkey].message) + 2
    else
      break
    endif
  endfor
  if self.win_is_open
    call self.__floating.win_config(self.winid,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : self.notification_width, 
          \ 'height'  : len(self.message),
          \ 'row': self.begin_row + 1,
          \ 'highlight' : self.notification_color,
          \ 'focusable' : v:false,
          \ 'col': &columns - self.notification_width - 1,
          \ })
    call self.__floating.win_config(self.border.winid,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : self.notification_width + 2, 
          \ 'height'  : len(self.message) + 2,
          \ 'row': self.begin_row,
          \ 'col': &columns - self.notification_width - 2,
          \ 'highlight' : 'VertSplit',
          \ 'focusable' : v:false,
          \ })
  else
    let self.winid =  self.__floating.open_win(self.bufnr, v:false,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : self.notification_width, 
          \ 'height'  : len(self.message),
          \ 'row': self.begin_row + 1,
          \ 'highlight' : self.notification_color,
          \ 'col': &columns - self.notification_width - 1,
          \ 'focusable' : v:false,
          \ })
    let self.border.winid =  self.__floating.open_win(self.border.bufnr, v:false,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : self.notification_width + 2, 
          \ 'height'  : len(self.message) + 2,
          \ 'row': self.begin_row,
          \ 'col': &columns - self.notification_width - 2,
          \ 'highlight' : 'VertSplit',
          \ 'focusable' : v:false,
          \ })
    let self.win_is_open = v:true
  endif
endfunction


function! SpaceVim#api#notification#get()

  return deepcopy(s:self)

endfunction

