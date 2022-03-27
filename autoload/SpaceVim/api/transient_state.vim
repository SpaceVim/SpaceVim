"=============================================================================
" transient_state.vim --- SpaceVim transient_state API
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:self = {}

let s:self._keys = {}
let s:self._on_syntax = ''
let s:self._title = 'Transient State'
let s:self._handle_inputs = {}
let s:self._is_quit = []
let s:self._handle_quit = {}
let s:self._clear_cmdline = 1
let s:self._cmp = SpaceVim#api#import('vim#compatible')
let s:self.__buffer = SpaceVim#api#import('vim#buffer')
let s:self.__vim = SpaceVim#api#import('vim')

function! s:self.open() abort
  noautocmd botright split __transient_state__
  let self._bufid = self.__buffer.bufnr()
  call self.__vim.setbufvar(self._bufid,
        \ {
        \ '&buftype' : 'nofile',
        \ '&bufhidden' : 'wipe',
        \ '&buflisted' : 0,
        \ '&list' : 0,
        \ '&swapfile' : 0,
        \ '&spell' : 0,
        \ '&number' : 0,
        \ '&relativenumber' : 0,
        \ '&filetype' : 'TransientState',
        \ }
        \ )
  if !empty(self._on_syntax) && type(self._on_syntax) ==# 2
    call call(self._on_syntax, [])
  else
    hi def link SpaceVim_Transient_State_Exit Keyword
    hi def link SpaceVim_Transient_State_Notexit Number
    hi def link SpaceVim_Transient_State_Title Title
  endif
  call setline(1, self._title)
  let b:transient_state_title = self._title
  call append(line('$'), '')
  call self.highlight_title()
  call self._update_content()
  call append(line('$'), '')
  call append(line('$'), '[KEY] exits state   [KEY] will not exit')
  call self.highlight_keys(1, line('$') - 1, 1, 4)
  call self.highlight_keys(0, line('$') - 1, 21, 24)
  if winheight(0) > line('$')
    exe 'resize ' .  line('$')
  endif
  " move to prvious window
  wincmd p
  if has_key(self._keys, 'init')
    call call(self._keys.init, [])
  endif
  while 1
    if has_key(self._keys, 'logo')
      noautocmd wincmd p
      call call(self._keys.logo, [])
      noautocmd wincmd p
    endif
    if self._clear_cmdline
      normal! :
    else
      let self._clear_cmdline = 1
    endif
    redraw
    let char = self.__vim.getchar()
    if char ==# "\<FocusLost>" || char ==# "\<FocusGained>" || char2nr(char) == 128
      continue
    endif
    if !has_key(self._handle_inputs, char)
      break
    else
      if type(self._handle_inputs[char]) == 2
        call call(self._handle_inputs[char], [])
      elseif type(self._handle_inputs[char]) == 1
        exe self._handle_inputs[char]
      endif
    endif
    if index(self._is_quit, char) != -1
      break
    endif
  endwhile
  exe 'bd ' . self._bufid
  doautocmd WinEnter
  if has_key(self._handle_quit, char)
    if type(self._handle_quit[char]) == 2
      call call(self._handle_quit[char], [])
    elseif type(self._handle_quit[char]) == 1
      exe self._handle_quit[char]
    endif
  endif
  if self._clear_cmdline
    normal! :
  else
    let self._clear_cmdline = 1
  endif
  redraw
endfunction

function! s:self.defind_keys(dict) abort
  let self._keys = a:dict
endfunction

function! s:self.set_syntax(func) abort
  let self._on_syntax = a:func
endfunction

function! s:self.set_title(title) abort
  let self._title = a:title
endfunction

if has('nvim')
  function! s:self.highlight_keys(exit, line, begin, end) abort
    " @bug nvim_buf_add_highlight do not warning for index out of range
    if a:exit
      call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Exit', a:line, a:begin, a:end)
    else
      call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Notexit', a:line, a:begin, a:end)
    endif
  endfunction
else
  function! s:self.highlight_keys(exit, line, begin, end) abort
    if a:exit
      call self._cmp.matchaddpos('SpaceVim_Transient_State_Exit', [[a:line + 1, a:begin + 1, a:end - a:begin]])
    else
      call self._cmp.matchaddpos('SpaceVim_Transient_State_Notexit', [[a:line + 1, a:begin + 1, a:end - a:begin]])
    endif
  endfunction
endif

if has('nvim')
  function! s:self.highlight_title() abort
    call nvim_buf_add_highlight(self._bufid, 0, 'SpaceVim_Transient_State_Title', 0, 0, len(self._title))
  endfunction
else
  function! s:self.highlight_title() abort
    call self._cmp.matchaddpos('SpaceVim_Transient_State_Title', [1])
  endfunction
endif

function! s:self._check_max_key_len() abort
  let self._linenum = max([len(self._keys.right), len(self._keys.left)])
  let self._left_max_key_len = 0
  for key in self._keys.left
    if type(key.key) == 1   " is a string
      let self._left_max_key_len = max([len(key.key), self._left_max_key_len])
    elseif type(key.key) == 3  " is a list
      let self._left_max_key_len = max([len(join(key.key, '/')), self._left_max_key_len])
    elseif type(key.key) == 4  " is a dict
      let self._left_max_key_len = max([len(key.key.name), self._left_max_key_len])
    endif
  endfor
  let self._right_max_key_len = 0
  for key in self._keys.right
    if type(key.key) == 1   " is a string
      let self._right_max_key_len = max([len(key.key), self._right_max_key_len])
    elseif type(key.key) == 3  " is a list
      let self._right_max_key_len = max([len(join(key.key, '/')), self._right_max_key_len])
    elseif type(key.key) == 4  " is a dict
      let self._right_max_key_len = max([len(key.key.name), self._right_max_key_len])
    endif
  endfor
endfunction

function! s:self._key_obj_to_hl_line(left, right, line) abort
  let line = ''
  let hls = []
  let i = a:line
  if !empty(a:left) && type(a:left.key) == 1
    if a:left.key ==# "\<tab>"
      let line .= '[Tab] ' . repeat(' ', self._left_max_key_len - len(a:left.key)) . a:left.desc 
      call add(hls, [a:left.exit, i + 2, 1 + self._log_width, 1 + self._log_width + 3])
    else
      let line .= '[' . a:left.key . '] ' . repeat(' ', self._left_max_key_len - len(a:left.key)) . a:left.desc 
      call add(hls, [a:left.exit, i + 2, 1 + self._log_width, 1 + self._log_width + len(a:left.key)])
    endif
    if !empty(a:left.cmd)
      call extend(self._handle_inputs, {a:left.key : a:left.cmd})
    elseif !empty(a:left.func)
      call extend(self._handle_inputs, {a:left.key : a:left.func})
    endif
    if a:left.exit
      call add(self._is_quit, a:left.key)
      if has_key(a:left, 'exit_cmd') && !empty(a:left.exit_cmd)
        call extend(self._handle_quit, {a:left.key : a:left.exit_cmd})
      endif
    endif
  elseif !empty(a:left) && type(a:left.key) == 3
    let line .= '[' . join(a:left.key, '/') . '] '
    let line .= repeat(' ', self._left_max_key_len - len(join(a:left.key, '/')))
    let line .= a:left.desc 
    let begin = 1 + self._log_width
    for key in a:left.key
      call add(hls, [a:left.exit, i + 2, begin, begin + len(key)])
      let begin = begin + len(key) + 1
    endfor
    if !empty(a:left.cmd)
      for key in a:left.key
        call extend(self._handle_inputs, {key : a:left.cmd})
      endfor
    elseif !empty(a:left.func)
      for key in a:left.key
        call extend(self._handle_inputs, {key : a:left.func})
      endfor
    endif
    if a:left.exit
      call extend(self._is_quit, a:left.key)
      " TODO: need fix
      " if has_key(left, 'exit_cmd') && !empty(left.exit_cmd)
      "   call extend(self._handle_quit, {left.key : left.exit_cmd})
      " endif
    endif
  elseif !empty(a:left) && type(a:left.key) == 4
    let line .= '[' . a:left.key.name . '] '
    let line .= repeat(' ', self._left_max_key_len - len(a:left.key.name))
    let line .= a:left.desc 
    for pos in a:left.key.pos
      call add(hls, [a:left.exit, i + 2, pos[0], pos[1]])
    endfor
    for handles in a:left.key.handles
      call extend(self._handle_inputs, {handles[0] : handles[1]})
    endfor
    if a:left.exit
      call extend(self._is_quit, keys(a:left.key))
      " TODO: need to fixed
      " if has_key(left, 'exit_cmd') && !empty(left.exit_cmd)
      "   call extend(self._handle_quit, {left.key : left.exit_cmd})
      " endif
    endif
  endif
  let line .= repeat(' ', 40 + self._log_width - len(line))
  if !empty(a:right) && type(a:right.key) == 1
    let line .= '[' . a:right.key . '] ' . repeat(' ', self._right_max_key_len - len(a:right.key)) . a:right.desc 
    call add(hls, [a:right.exit, i + 2, 41 + self._log_width, 41 + self._log_width + len(a:right.key)])
    if !empty(a:right.cmd)
      call extend(self._handle_inputs, {a:right.key : a:right.cmd})
    elseif !empty(a:right.func)
      call extend(self._handle_inputs, {a:right.key : a:right.func})
    endif
    if a:right.exit
      call add(self._is_quit, a:right.key)
      if has_key(a:right, 'exit_cmd') && !empty(a:right.exit_cmd)
        call extend(self._handle_quit, {a:right.key : a:right.exit_cmd})
      endif
    endif
  elseif !empty(a:right) && type(a:right.key) == 3
    let line .= '[' . join(a:right.key, '/') . '] '
    let line .= repeat(' ', self._right_max_key_len - len(join(a:right.key, '/')))
    let line .= a:right.desc 
    let begin = 41 + self._log_width
    for key in a:right.key
      call add(hls, [a:right.exit, i + 2, begin, begin + len(key)])
      let begin = begin + len(key) + 1
    endfor
    if !empty(a:right.cmd)
      for key in a:right.key
        call extend(self._handle_inputs, {key : a:right.cmd})
      endfor
    elseif !empty(a:right.func)
      for key in a:right.key
        call extend(self._handle_inputs, {key : a:right.func})
      endfor
    endif
    if a:right.exit
      call extend(self._is_quit, a:right.key)
      " TODO: need fix
      " if has_key(right, 'exit_cmd') && !empty(right.exit_cmd)
      "   call extend(self._handle_quit, {right.key : right.exit_cmd})
      " endif
    endif
  elseif !empty(a:right) && type(a:right.key) == 4
    let line .= '[' . a:right.key.name . '] '
    let line .= repeat(' ', self._right_max_key_len - len(a:right.key.name))
    let line .= a:right.desc 
    let begin = 41 + self._log_width
    for pos in a:right.key.pos
      call add(hls, [a:right.exit, i + 2, begin + pos[0], begin + pos[1]])
    endfor
    for handles in a:right.key.handles
      call extend(self._handle_inputs, {handles[0] : handles[1]})
    endfor
    if a:right.exit
      call extend(self._is_quit, keys(a:right.key))
      " TODO: need fix
      " if has_key(right, 'exit_cmd') && !empty(right.exit_cmd)
      "   call extend(self._handle_quit, {right.key : right.exit_cmd})
      " endif
    endif
  endif
  return [line, hls]
endfunction

function! s:self._update_content() abort
  if get(self._keys, 'layout', '') ==# 'vertical split'
    call self._check_max_key_len()
    if has_key(self._keys, 'logo') && has_key(self._keys, 'self._log_width')
      let self._log_width = self._keys.self._log_width
    else
      let self._log_width = 0
    endif
    for i in range(self._linenum)
      let left = get(self._keys.left, i, {})
      let right = get(self._keys.right, i, {})
      let line = repeat(' ', self._log_width)
      let [line, hls] = self._key_obj_to_hl_line(left, right, i)
      call append(line('$'), line)
      for hl in hls
        call call(self.highlight_keys, hl)
      endfor
    endfor
  endif
endfunction

function! SpaceVim#api#transient_state#get() abort
  return deepcopy(s:self)
endfunction
