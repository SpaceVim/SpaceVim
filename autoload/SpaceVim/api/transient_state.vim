"=============================================================================
" transient_state.vim --- SpaceVim transient_state API
" Copyright (c) 2016-2019 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
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

function! s:self.open() abort
  noautocmd botright split __transient_state__
  let self._bufid = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  set filetype=TransientState
  " let save_tve = &t_ve
  " setlocal t_ve=
  " setlocal nomodifiable
  " setf SpaceVimFlyGrep
  " let &t_ve = save_tve
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
    let char = self._getchar()
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



function! s:self._getchar(...) abort
  let ret = call('getchar', a:000)
  return (type(ret) == type(0) ? nr2char(ret) : ret)
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

function! s:self._update_content() abort
  if get(self._keys, 'layout', '') ==# 'vertical split'
    let linenum = max([len(self._keys.right), len(self._keys.left)])
    let left_max_key_len = 0
    for key in self._keys.left
      if type(key.key) == 1   " is a string
        let left_max_key_len = max([len(key.key), left_max_key_len])
      elseif type(key.key) == 3  " is a list
        let left_max_key_len = max([len(join(key.key, '/')), left_max_key_len])
      elseif type(key.key) == 4  " is a dict
        let left_max_key_len = max([len(key.key.name), left_max_key_len])
      endif
    endfor
    let right_max_key_len = 0
    for key in self._keys.right
      if type(key.key) == 1   " is a string
        let right_max_key_len = max([len(key.key), right_max_key_len])
      elseif type(key.key) == 3  " is a list
        let right_max_key_len = max([len(join(key.key, '/')), right_max_key_len])
      elseif type(key.key) == 4  " is a dict
        let right_max_key_len = max([len(key.key.name), right_max_key_len])
      endif
    endfor

    if has_key(self._keys, 'logo') && has_key(self._keys, 'logo_width')
      let logo_width = self._keys.logo_width
    else
      let logo_width = 0
    endif
    for i in range(linenum)
      let left = get(self._keys.left, i)
      let right = get(self._keys.right, i)
      let line = repeat(' ', logo_width)
      if !empty(left)
        if type(left.key) == 1
          if left.key ==# "\<tab>"
            let line .= '[Tab] ' . repeat(' ', left_max_key_len - len(left.key)) . left.desc 
            call self.highlight_keys(left.exit, i + 2, 1 + logo_width, 1 + logo_width + 3)
          else
            let line .= '[' . left.key . '] ' . repeat(' ', left_max_key_len - len(left.key)) . left.desc 
            call self.highlight_keys(left.exit, i + 2, 1 + logo_width, 1 + logo_width + len(left.key))
          endif
          if !empty(left.cmd)
            call extend(self._handle_inputs, {left.key : left.cmd})
          elseif !empty(left.func)
            call extend(self._handle_inputs, {left.key : left.func})
          endif
          if left.exit
            call add(self._is_quit, left.key)
            if has_key(left, 'exit_cmd') && !empty(left.exit_cmd)
              call extend(self._handle_quit, {left.key : left.exit_cmd})
            endif
          endif
        elseif type(left.key) == 3
          let line .= '[' . join(left.key, '/') . '] '
          let line .= repeat(' ', left_max_key_len - len(join(left.key, '/')))
          let line .= left.desc 
          let begin = 1 + logo_width
          for key in left.key
            call self.highlight_keys(left.exit, i + 2, begin, begin + len(key))
            let begin = begin + len(key) + 1
          endfor
          if !empty(left.cmd)
            for key in left.key
              call extend(self._handle_inputs, {key : left.cmd})
            endfor
          elseif !empty(left.func)
            for key in left.key
              call extend(self._handle_inputs, {key : left.func})
            endfor
          endif
          if left.exit
            call extend(self._is_quit, left.key)
            " TODO: need fix
            " if has_key(left, 'exit_cmd') && !empty(left.exit_cmd)
            "   call extend(self._handle_quit, {left.key : left.exit_cmd})
            " endif
          endif
        elseif type(left.key) == 4
          let line .= '[' . left.key.name . '] '
          let line .= repeat(' ', left_max_key_len - len(left.key.name))
          let line .= left.desc 
          for pos in left.key.pos
            call self.highlight_keys(left.exit, i + 2, pos[0], pos[1])
          endfor
          for handles in left.key.handles
            call extend(self._handle_inputs, {handles[0] : handles[1]})
          endfor
          if left.exit
            call extend(self._is_quit, keys(left.key))
            " TODO: need to fixed
            " if has_key(left, 'exit_cmd') && !empty(left.exit_cmd)
            "   call extend(self._handle_quit, {left.key : left.exit_cmd})
            " endif
          endif
        endif
      endif
      let line .= repeat(' ', 40 + logo_width - len(line))
      if !empty(right)
        if type(right.key) == 1
          let line .= '[' . right.key . '] ' . repeat(' ', right_max_key_len - len(right.key)) . right.desc 
          call self.highlight_keys(right.exit, i + 2, 41 + logo_width, 41 + logo_width + len(right.key))
          if !empty(right.cmd)
            call extend(self._handle_inputs, {right.key : right.cmd})
          elseif !empty(right.func)
            call extend(self._handle_inputs, {right.key : right.func})
          endif
          if right.exit
            call add(self._is_quit, right.key)
            if has_key(right, 'exit_cmd') && !empty(right.exit_cmd)
              call extend(self._handle_quit, {right.key : right.exit_cmd})
            endif
          endif
        elseif type(right.key) == 3
          let line .= '[' . join(right.key, '/') . '] '
          let line .= repeat(' ', right_max_key_len - len(join(right.key, '/')))
          let line .= right.desc 
          let begin = 41 + logo_width
          for key in right.key
            call self.highlight_keys(right.exit, i + 2, begin, begin + len(key))
            let begin = begin + len(key) + 1
          endfor
          if !empty(right.cmd)
            for key in right.key
              call extend(self._handle_inputs, {key : right.cmd})
            endfor
          elseif !empty(right.func)
            for key in right.key
              call extend(self._handle_inputs, {key : right.func})
            endfor
          endif
          if right.exit
            call extend(self._is_quit, right.key)
            " TODO: need fix
            " if has_key(right, 'exit_cmd') && !empty(right.exit_cmd)
            "   call extend(self._handle_quit, {right.key : right.exit_cmd})
            " endif
          endif
        elseif type(right.key) == 4
          let line .= '[' . right.key.name . '] '
          let line .= repeat(' ', right_max_key_len - len(right.key.name))
          let line .= right.desc 
          let begin = 41 + logo_width
          for pos in right.key.pos
            call self.highlight_keys(right.exit, i + 2, begin + pos[0], begin + pos[1])
          endfor
          for handles in right.key.handles
            call extend(self._handle_inputs, {handles[0] : handles[1]})
          endfor
          if right.exit
            call extend(self._is_quit, keys(right.key))
            " TODO: need fix
            " if has_key(right, 'exit_cmd') && !empty(right.exit_cmd)
            "   call extend(self._handle_quit, {right.key : right.exit_cmd})
            " endif
          endif
        endif
      endif
      call append(line('$'), line)
    endfor
  endif
endfunction

function! SpaceVim#api#transient_state#get() abort
  return deepcopy(s:self)
endfunction
