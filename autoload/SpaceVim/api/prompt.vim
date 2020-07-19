"=============================================================================
" prompt.vim --- SpaceVim prompt API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section prompt, api-prompt
" @parentsection api
" open()
"
" Create a cmdline prompt, use while loop to get the input from user. The
" default mapping for prompt is:
" >
"   <Bs>            remove last character
"   <C-w>           remove the Word before the cursor
"   <C-u>           remove the Line before the cursor
"   <C-k>           remove the Line after the cursor
"   <C-a> / <Home>  Go to the beginning of the line
"   <C-e> / <End>   Go to the end of the line
" <

let s:self = {}
let s:self.__cmp = SpaceVim#api#import('vim#compatible')


let s:self._keys = {
      \ 'close' : "\<Esc>",
      \ }
let s:self._prompt = {
      \ 'mpt' : '==>',
      \ 'begin' : '',
      \ 'cursor' : '',
      \ 'end' : '',
      \ }
let s:self._function_key = {}

let s:self._quit = 1

let s:self._handle_fly = ''
let s:self._onclose = ''
let s:self._oninputpro = ''



func! s:self.open() abort
  let self._quit = 0
  let save_redraw = &lazyredraw
  set nolazyredraw
  call self._build_prompt()
  if !empty(self._prompt.begin)
    call self._handle_input(self._prompt.begin)
  else
    call self._handle_input()
  endif
  let &lazyredraw = save_redraw
endf

func! s:self._c_r_mode_off(timer) abort
  let self._c_r_mode = 0
endf

function! s:self._getchar(...) abort
  let ret = call('getchar', a:000)
  " @bug getchar() does not work for <
  " https://github.com/neovim/neovim/issues/12487
  if ret ==# "\x80\xfc\<C-b><"
    return '<'
  endif
  return (type(ret) == type(0) ? nr2char(ret) : ret)
endfunction

func! s:self._handle_input(...) abort
  let begin = get(a:000, 0, '')
  if !empty(begin)
    if self._oninputpro !=# ''
      call call(self._oninputpro, [])
    endif
    if self._handle_fly !=# ''
      call call(self._handle_fly, [self._prompt.begin . self._prompt.cursor . self._prompt.end])
    endif
    call self._build_prompt()
  endif
  let self._c_r_mode = 0
  while self._quit == 0
    let char = self._getchar()
    if has_key(self._function_key, char)
      call call(self._function_key[char], [])
      continue
    endif
    if self._c_r_mode ==# 1 && char =~# '[a-zA-Z0-9"+:/]'
      let reg = '@' . char
      let paste = get(split(eval(reg), "\n"), 0, '')
      let self._prompt.begin = self._prompt.begin . paste
      let self._prompt.cursor = matchstr(self._prompt.end, '.$')
      let self._c_r_mode = 0
      call self._build_prompt()
    elseif char ==# "\<C-r>"
      let self._c_r_mode = 1
      call timer_start(2000, self._c_r_mode_off)
      call self._build_prompt()
      continue
    elseif char ==# "\<Right>"
      let self._prompt.begin = self._prompt.begin . self._prompt.cursor
      let self._prompt.cursor = matchstr(self._prompt.end, '^.')
      let self._prompt.end = substitute(self._prompt.end, '^.', '', 'g')
      call self._build_prompt()
      continue
    elseif char ==# "\<Left>"
      if self._prompt.begin !=# ''
        let self._prompt.end = self._prompt.cursor . self._prompt.end
        let self._prompt.cursor = matchstr(self._prompt.begin, '.$')
        let self._prompt.begin = substitute(self._prompt.begin, '.$', '', 'g')
        call self._build_prompt()
      endif
      continue
    elseif char ==# "\<C-w>"
      let self._prompt.begin = substitute(self._prompt.begin,'[^\ .*]\+\s*$','','g')
      call self._build_prompt()
    elseif char ==# "\<C-a>"  || char ==# "\<Home>"
      let self._prompt.end = substitute(self._prompt.begin . self._prompt.cursor . self._prompt.end, '^.', '', 'g')
      let self._prompt.cursor = matchstr(self._prompt.begin, '^.')
      let self._prompt.begin = ''
      call self._build_prompt()
      continue
    elseif char ==# "\<C-e>"  || char ==# "\<End>"
      let self._prompt.begin = self._prompt.begin . self._prompt.cursor . self._prompt.end
      let self._prompt.cursor = ''
      let self._prompt.end = ''
      call self._build_prompt()
      continue
    elseif char ==# "\<C-u>"
      let self._prompt.begin = ''
      call self._build_prompt()
    elseif char ==# "\<C-k>"
      let self._prompt.cursor = ''
      let self._prompt.end = ''
      call self._build_prompt()
    elseif char ==# "\<bs>"
      let self._prompt.begin = substitute(self._prompt.begin,'.$','','g')
      call self._build_prompt()
    elseif (type(self._keys.close) == 1 && char == self._keys.close)
          \ || (type(self._keys.close) == 3 && index(self._keys.close, char) > -1 )
      call self.close()
      break
    elseif char ==# "\<FocusLost>" || char ==# "\<FocusGained>" || char2nr(char) == 128
      continue
    else
      let self._prompt.begin .= char
      call self._build_prompt()
    endif
    if self._oninputpro !=# ''
      call call(self._oninputpro, [])
    endif
    if self._handle_fly !=# ''
      call call(self._handle_fly, [self._prompt.begin . self._prompt.cursor . self._prompt.end])
    endif
  endwhile
endf

func! s:self._build_prompt() abort
  let ident = repeat(' ', self.__cmp.win_screenpos(0)[1] - 1)
  redraw
  echohl Comment | echon ident . self._prompt.mpt
  echohl None | echon self._prompt.begin
  echohl Wildmenu | echon self._prompt.cursor
  echohl None | echon self._prompt.end
  if empty(self._prompt.cursor) && !has('nvim')
    echohl Comment | echon '_' | echohl None
  endif
  " FIXME: Macvim need extra redraw, 
endf

function! s:self._clear_prompt() abort
  let self._prompt = {
        \ 'mpt' : self._prompt.mpt,
        \ 'begin' : '',
        \ 'cursor' : '',
        \ 'end' : '',
        \ }
endfunction

function! s:self.close() abort
  if self._onclose !=# ''
    call call(self._onclose, [])
  endif
  call self._clear_prompt()
  normal! :
  let self._quit = 1
endfunction

function! SpaceVim#api#prompt#get() abort
  return deepcopy(s:self)
endfunction
