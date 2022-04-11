"=============================================================================
" notify.vim --- notify api
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================
scriptencoding utf-8

""
" @section notify, api-notify
" @parentsection api
" The notification api for SpaceVim
"
" notify({msg} [, {Color}[, {option}]])
"
" Use floating windows to display notification {msg}. The {msg} should a no
" empty string. {Color} is the name of highlight ground defined in Vim. The
" {option} is a dictionary which support following key:
"
" - `winblend`: enable transparency for the notify windows. Valid values
"   are in the range of 0 to 100. Default is 0.
"
" NOTE: Floating windows support pseudo-transparency (:help 'winblend')
" in #neovim HEAD (v0.4.x). 
" 

" Global values, this can be used between different notify

let s:notifications = {}

" dictionary values and functions

let s:self = {}
let s:self.message = []
let s:self.notification_width = 1
" this should be changed based on the windows
" if user do not set the notify_max_width, it should use default,
" it should based on the really windows width
let s:self.notify_max_width = 0
let s:self.winid = -1
let s:self.bufnr = -1
let s:self.border = {}
let s:self.border.winid = -1
let s:self.border.bufnr = -1
let s:self.borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let s:self.title = ''
let s:self.winblend = 0
let s:self.timeout = 3000
let s:self.hashkey = ''
let s:self.config = {}
let s:self.config.icons = {
      \ 'ERROR' : '',
      \ 'WARN' : '',
      \ 'INFO' : '',
      \ 'DEBUG' : '',
      \ 'TRACE' : '✎',
      \ }
let s:self.config.title = 'SpaceVim'

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

function! s:self.win_is_open() abort
  try
    if exists('*nvim_win_get_config')
      return self.winid >= 0 && self.border.winid >= 0
            \ && has_key(nvim_win_get_config(self.winid), 'col')
            \ && has_key(nvim_win_get_config(self.border.winid), 'col')
    elseif exists('*popup_getoptions')
      return self.winid >= 0 && self.border.winid >= 0
            \ && has_key(popup_getoptions(self.winid), 'col')
            \ && has_key(popup_getoptions(self.border.winid), 'col')
    endif
  catch
    return 0
  endtry
endfunction

function! s:self.increase_window(...) abort
  " let self.notification_width = self.__floating.get_width(self.winid)
  if self.notification_width <= self.notify_max_width && self.win_is_open()
    let self.notification_width += min([float2nr((self.notify_max_width - self.notification_width) * 1 / 10), float2nr(self.notify_max_width)])
    call self.__buffer.buf_set_lines(self.border.bufnr, 0 , -1, 0,
          \ self.draw_border(self.title, self.notification_width, len(self.message)))
    call self.redraw_windows()
    call timer_start(30, self.increase_window, {'repeat' : 1})
  endif
endfunction

function! s:self.string_compose(target, pos, source) abort
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


function! s:self.close(...) abort
  if !empty(self.message)
    call remove(self.message, 0)
  endif
  if len(self.message) == 0
    if self.win_is_open()
      noautocmd call self.__floating.win_close(self.border.winid, v:true)
      noautocmd call self.__floating.win_close(self.winid, v:true)
    endif
    if has_key(s:notifications, self.hashkey)
      call remove(s:notifications, self.hashkey)
    endif
    let self.notification_width = 1
  endif
  for hashkey in keys(s:notifications)
    call s:notifications[hashkey].redraw_windows()
  endfor
endfunction

function! s:self.close_all() abort
  let self.message = []
  if self.win_is_open()
    noautocmd call self.__floating.win_close(self.border.winid, v:true)
    noautocmd call self.__floating.win_close(self.winid, v:true)
  endif
  if has_key(s:notifications, self.hashkey)
    call remove(s:notifications, self.hashkey)
  endif
  let self.notification_width = 1
endfunction

function! s:self.notify(msg, ...) abort
  if self.notify_max_width ==# 0
    let self.notify_max_width = &columns * 0.3
  endif
  call add(self.message, a:msg)
  let self.notification_color = get(a:000, 0, 'Normal')
  let options = get(a:000, 1, {}) 
  let self.winblend = get(options, 'winblend', self.winblend)
  if empty(self.hashkey)
    let self.hashkey = self.__password.generate_simple(10)
  endif
  call self.redraw_windows()
  call setbufvar(self.bufnr, '&number', 0)
  call setbufvar(self.bufnr, '&relativenumber', 0)
  call setbufvar(self.bufnr, '&cursorline', 0)
  call setbufvar(self.bufnr, '&bufhidden', 'wipe')
  call setbufvar(self.border.bufnr, '&number', 0)
  call setbufvar(self.border.bufnr, '&relativenumber', 0)
  call setbufvar(self.border.bufnr, '&cursorline', 0)
  call setbufvar(self.border.bufnr, '&bufhidden', 'wipe')
  call extend(s:notifications, {self.hashkey : self})
  call self.increase_window()
  call timer_start(self.timeout, self.close, {'repeat' : 1})
endfunction

function! s:self.redraw_windows() abort
  if empty(self.message)
    return
  endif
  let self.begin_row = 2
  for hashkey in keys(s:notifications)
    if hashkey !=# self.hashkey
      let self.begin_row += len(s:notifications[hashkey].message) + 2
    else
      break
    endif
  endfor
  if self.win_is_open()
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
    if !bufexists(self.border.bufnr)
      let self.border.bufnr = self.__buffer.create_buf(0, 1)
    endif
    if !bufexists(self.bufnr)
      let self.bufnr = self.__buffer.create_buf(0, 1)
    endif
    noautocmd let self.winid =  self.__floating.open_win(self.bufnr, v:false,
          \ {
            \ 'relative': 'editor',
            \ 'width'   : self.notification_width, 
            \ 'height'  : len(self.message),
            \ 'row': self.begin_row + 1,
            \ 'highlight' : self.notification_color,
            \ 'col': &columns - self.notification_width - 1,
            \ 'focusable' : v:false,
            \ })
    noautocmd let self.border.winid =  self.__floating.open_win(self.border.bufnr, v:false,
          \ {
            \ 'relative': 'editor',
            \ 'width'   : self.notification_width + 2, 
            \ 'height'  : len(self.message) + 2,
            \ 'row': self.begin_row,
            \ 'col': &columns - self.notification_width - 2,
            \ 'highlight' : 'VertSplit',
            \ 'focusable' : v:false,
            \ })
    if self.winblend > 0 && exists('&winblend')
          \ && exists('*nvim_win_set_option')
      call nvim_win_set_option(self.winid, 'winblend', self.winblend)
      call nvim_win_set_option(self.border.winid, 'winblend', self.winblend)
    endif
  endif
  call self.__buffer.buf_set_lines(self.border.bufnr, 0 , -1, 0,
        \ self.draw_border(self.title, self.notification_width, len(self.message)))
  call self.__buffer.buf_set_lines(self.bufnr, 0 , -1, 0, self.message)
endfunction


function! SpaceVim#api#notify#get() abort

  return deepcopy(s:self)

endfunction


