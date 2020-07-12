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
let s:self.border.winid = -1
let s:self.borderchars = ['─', '│', '─', '│', '┌', '┐', '┘', '└']
let s:self.title = ''

if has('nvim')
    let s:self.__floating = SpaceVim#api#import('neovim#floating')
else
    let s:self.__floating = SpaceVim#api#import('vim#floating')
endif
let s:BUFFER = SpaceVim#api#import('vim#buffer')

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


let s:buffer_id = s:BUFFER.bufadd('')
let s:timer_id = -1

let s:win_is_open = v:false

function! s:close(...) abort
    if len(s:shown) == 1
        noautocmd call self.__floating.win_close(s:notification_winid, v:true)
        let s:win_is_open = v:false
    endif
    if !empty(s:shown)
        call add(s:messages, remove(s:shown, 0))
    endif
endfunction

function! s:self.notification(msg, color) abort
    call add(s:shown, a:msg)
    if s:win_is_open
        call self.__floating.win_config(s:notification_winid,
                    \ {
                    \ 'relative': 'editor',
                    \ 'width'   : strwidth(a:msg), 
                    \ 'height'  : 1 + len(s:shown),
                    \ 'row': 2,
                    \ 'highlight' : a:color,
                    \ 'col': &columns - strwidth(a:msg) - 3
                    \ })
    else
        let s:notification_winid =  self.__floating.open_win(s:buffer_id, v:false,
                    \ {
                    \ 'relative': 'editor',
                    \ 'width'   : strwidth(a:msg), 
                    \ 'height'  : 1 + len(s:shown),
                    \ 'row': 2,
                    \ 'highlight' : a:color,
                    \ 'col': &columns - strwidth(a:msg) - 3
                    \ })
        let s:win_is_open = v:true
    endif
    call s:BUFFER.buf_set_lines(s:buffer_id, 0 , -1, 0, s:shown)
    if exists('&winhighlight')
        call setbufvar(s:buffer_id, '&winhighlight', 'Normal:' . a:color)
    endif
    call setbufvar(s:buffer_id, '&number', 0)
    call setbufvar(s:buffer_id, '&relativenumber', 0)
    call setbufvar(s:buffer_id, '&buftype', 'nofile')
    let s:timer_id = timer_start(3000, function('s:close'), {'repeat' : 1})
endfunction


function! SpaceVim#api#notification#get()

    return deepcopy(s:self)

endfunction

