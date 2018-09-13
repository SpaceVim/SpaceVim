"=============================================================================
" flygrep.vim --- Grep on the fly in SpaceVim
" Copyright (c) 2016-2017 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Loadding SpaceVim api {{{
scriptencoding utf-8
let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
let s:SYS = SpaceVim#api#import('system')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:LIST = SpaceVim#api#import('data#list')
"}}}

" Init local options: {{{
let s:grep_expr = ''
let [
      \ s:grep_default_exe,
      \ s:grep_default_opt,
      \ s:grep_default_ropt,
      \ s:grep_default_expr_opt,
      \ s:grep_default_fix_string_opt,
      \ s:grep_default_ignore_case,
      \ s:grep_default_smart_case
      \ ] = SpaceVim#mapping#search#default_tool()
let s:grep_timer_id = -1
let s:grepid = 0
let s:grep_history = []
let s:complete_input_history_num = [0,0]
" }}}

" grep local funcs:{{{
" @vimlint(EVL103, 1, a:timer)
let s:current_grep_pattern = ''
function! s:grep_timer(timer) abort
  if s:grep_mode ==# 'expr'
    let s:current_grep_pattern = join(split(s:grep_expr), '.*')
  else
    let s:current_grep_pattern = s:grep_expr
  endif
  let cmd = s:get_search_cmd(s:current_grep_pattern)
  call SpaceVim#logger#info('grep cmd: ' . string(cmd))
  let s:grepid =  s:JOB.start(cmd, {
        \ 'on_stdout' : function('s:grep_stdout'),
        \ 'on_stderr' : function('s:grep_stderr'),
        \ 'in_io' : 'null',
        \ 'on_exit' : function('s:grep_exit'),
        \ })
endfunction

function! s:get_search_cmd(expr) abort
  let cmd = [s:grep_exe] + s:grep_opt
  if &ignorecase
    let cmd += s:grep_ignore_case
  endif
  if &smartcase
    let cmd += s:grep_smart_case
  endif
  if s:grep_mode ==# 'string'
    let cmd += s:grep_default_fix_string_opt
  endif
  let cmd += s:grep_expr_opt
  if !empty(s:grep_files) && type(s:grep_files) == 3
    let cmd += [a:expr] + s:grep_files
  elseif !empty(s:grep_files) && type(s:grep_files) == 1
    let cmd += [a:expr] + [s:grep_files]
  elseif !empty(s:grep_dir)
    let cmd += [a:expr] + [s:grep_dir]
  else
    let cmd += [a:expr] + s:grep_ropt
  endif
  " let cmd = map(cmd, 'shellescape(v:val)')
  " if has('win32')
  " let cmd += ['|', 'select', '-first', '3000']
  " else
  " let cmd += ['|', 'head', '-3000']
  " endif
  " let cmd = join(cmd, ' ')
  return cmd
endfunction

" s:grep_mode expr or string
" argv:expr is the input content from user
" return a pattern for s:matchadd
function! s:expr_to_pattern(expr) abort
  if s:grep_mode ==# 'expr'
    let items = split(a:expr)
    return join(items, '\|')
  else
    return a:expr
  endif
endfunction

function! s:matchadd(group, partten, propty) abort
  try
    return matchadd(a:group, a:partten, a:propty)
  catch /^Vim\%((\a\+)\)\=:E54/
    let partten = substitute(a:partten, '\\(', '(', 'g')
    try
      return matchadd(a:group, partten, a:propty)
    catch
      return -1
    endtry
  catch /^Vim\%((\a\+)\)\=:E55/
    let partten = substitute(a:partten, '\\)', ')', 'g')
    try
      return matchadd(a:group, partten, a:propty)
    catch
      return -1
    endtry
  catch 
    return -1
  endtry
endfunction

function! s:flygrep(expr) abort
  call s:MPT._build_prompt()
  if a:expr ==# ''
    redrawstatus
    return
  endif
  try 
    call matchdelete(s:hi_id)
  catch
  endtr
  hi def link FlyGrepPattern MoreMsg
  let s:hi_id = s:matchadd('FlyGrepPattern', s:expr_to_pattern(a:expr), 2)
  let s:grep_expr = a:expr
  call timer_stop(s:grep_timer_id)
  let s:grep_timer_id = timer_start(200, function('s:grep_timer'), {'repeat' : 1})
endfunction

" }}}

" filter local funcs: {{{
" @vimlint(EVL103, 0, a:timer)
let s:filter_file = ''
function! s:start_filter() abort
  let s:mode = 'f'
  redrawstatus
  let s:MPT._handle_fly = function('s:filter')
  let s:MPT._prompt = {
        \ 'mpt' : s:MPT._prompt.mpt,
        \ 'begin' : '',
        \ 'cursor' : '',
        \ 'end' : '',
        \ }
  let s:filter_file = tempname()
  try
    call writefile(getbufline('%', 1, '$'), s:filter_file, 'b')
  catch
    call SpaceVim#logger#info('FlyGrep: Failed to write filter content to temp file')
  endtry
  call s:MPT._build_prompt()
endfunction

function! s:filter(expr) abort
  call s:MPT._build_prompt()
  if a:expr ==# ''
    redrawstatus
    return
  endif
  try 
    call matchdelete(s:hi_id)
  catch
  endtr
  hi def link FlyGrepPattern MoreMsg
  let s:hi_id = s:matchadd('FlyGrepPattern', s:expr_to_pattern(a:expr), 2)
  let s:grep_expr = a:expr
  let s:grep_timer_id = timer_start(200, function('s:filter_timer'), {'repeat' : 1})
endfunction

" @vimlint(EVL103, 1, a:timer)
function! s:filter_timer(timer) abort
  let cmd = s:get_filter_cmd(join(split(s:grep_expr), '.*'))
  let s:grepid =  s:JOB.start(cmd, {
        \ 'on_stdout' : function('s:grep_stdout'),
        \ 'in_io' : 'null',
        \ 'on_exit' : function('s:grep_exit'),
        \ })
endfunction
" @vimlint(EVL103, 0, a:timer)

function! s:get_filter_cmd(expr) abort
  let cmd = [s:grep_exe] + SpaceVim#mapping#search#getFopt(s:grep_exe)
  return cmd + [a:expr] + [s:filter_file]
endfunction
" }}}

" replace local funcs {{{
function! s:start_replace() abort
  let s:mode = 'r'
  try 
    call matchdelete(s:hi_id)
  catch
  endtr
  let replace_text = s:current_grep_pattern
  if !empty(replace_text)
    call SpaceVim#plugins#iedit#start({'expr' : replace_text}, line('w0'), line('w$'))
  endif
  let s:hi_id = s:matchadd('FlyGrepPattern', s:expr_to_pattern(replace_text), 2)
  redrawstatus
endfunction
" }}}

" API: MPT._prompt {{{
let s:MPT._prompt.mpt = '➭ '
" }}}

" API: MPT._onclose {{{
function! s:close_buffer() abort
  if s:grepid != 0
    call s:JOB.stop(s:grepid)
  endif
  call timer_stop(s:grep_timer_id)
  noautocmd pclose
  noautocmd q
endfunction
let s:MPT._onclose = function('s:close_buffer')
" }}}

" API: MPT._oninputpro {{{
function! s:close_grep_job() abort
  if s:grepid != 0
    call s:JOB.stop(s:grepid)
  endif
  call timer_stop(s:grep_timer_id)
  normal! "_ggdG
endfunction

let s:MPT._oninputpro = function('s:close_grep_job')
" }}}

function! s:file_line(line) abort
  return matchstr(a:line, '[^:]*:\d\+:')
endfunction

" FlyGrep job handles: {{{
" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:id)
" @vimlint(EVL103, 1, a:event)
function! s:grep_stdout(id, data, event) abort
  let datas =filter(a:data, '!empty(v:val)')
  " let datas = s:LIST.uniq_by_func(datas, function('s:file_line'))
  if bufnr('%') == s:flygrep_buffer_id
    if getline(1) ==# ''
      call setline(1, datas)
    else
      call append('$', datas)
    endif
  endif
endfunction

function! s:grep_stderr(id, data, event) abort
  call SpaceVim#logger#error(' flygerp stderr: ' . string(a:data))
endfunction

function! s:grep_exit(id, data, event) abort
  redrawstatus
  let s:grepid = 0
endfunction
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:event)
"}}}

" FlyGrep Key prompt key bindings: {{{
function! s:next_item() abort
  if line('.') == line('$')
    normal! gg
  else
    normal! j
  endif
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_up() abort
  exe "normal! \<PageUp>"
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_down() abort
  exe "normal! \<PageDown>"
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_home() abort
  normal! gg
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_end() abort
  normal! G
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:previous_item() abort
  if line('.') == 1
    normal! G
  else
    normal! k
  endif
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:open_item() abort
  call add(s:grep_history, s:grep_expr)
  let s:MPT._handle_fly = function('s:flygrep')
  if getline('.') !=# ''
    if s:grepid != 0
      call s:JOB.stop(s:grepid)
    endif
    call s:MPT._clear_prompt()
    let s:MPT._quit = 1
    let line = getline('.')
    let filename = fnameescape(split(line, ':\d\+:')[0])
    let linenr = matchstr(line, ':\d\+:')[1:-2]
    let colum = matchstr(line, '\(:\d\+\)\@<=:\d\+:')[1:-2]
    noautocmd q
    exe 'e ' . filename
    call cursor(linenr, colum)
    noautocmd normal! :
  endif
endfunction

function! s:double_click() abort
  if line('.') !=# ''
    if s:grepid != 0
      call s:JOB.stop(s:grepid)
    endif
    call s:MPT._clear_prompt()
    let s:MPT._quit = 1
    let isfname = &isfname
    if s:SYS.isWindows
      set isfname-=:
    endif
    normal! gF
    let nr = bufnr('%')
    q
    exe 'silent b' . nr
    normal! :
    let &isfname = isfname
  endif
endfunction

function! s:move_cursor() abort
  if v:mouse_win == winnr()
    let cl = line('.')
    if cl < v:mouse_lnum
      exe 'normal! ' . (v:mouse_lnum - cl) . 'j'
    elseif cl > v:mouse_lnum
      exe 'normal! ' . (cl - v:mouse_lnum) . 'k'
    endif
  endif
  call s:MPT._build_prompt()
endfunction

let s:preview_able = 0
function! s:toggle_preview() abort
  if s:preview_able == 0
    let s:preview_able = 1
    call s:preview()
  else
    pclose
    let s:preview_able = 0
  endif
  redraw
  call s:MPT._build_prompt()
endfunction

function! s:preview() abort
  let line = getline('.')
  let filename = fnameescape(split(line, ':\d\+:')[0])
  let linenr = matchstr(line, ':\d\+:')[1:-2]
  exe 'silent pedit! +' . linenr . ' ' . filename
  resize 18
endfunction

let s:grep_mode = 'expr'
function! s:toggle_expr_mode() abort
  if s:grep_mode ==# 'expr'
    let s:grep_mode = 'string'
  else
    let s:grep_mode = 'expr'
  endif
  call s:MPT._oninputpro()
  call s:MPT._handle_fly(s:MPT._prompt.begin . s:MPT._prompt.cursor .s:MPT._prompt.end)
endfunction

let s:complete_input_history_base = ''
function! s:previous_match_history() abort
  if s:complete_input_history_num == [0,0]
    let s:complete_input_history_base = s:MPT._prompt.begin
    let s:MPT._prompt.cursor = ''
    let s:MPT._prompt.end = ''
  else
    let s:MPT._prompt.begin = s:complete_input_history_base
  endif
  let s:complete_input_history_num[0] += 1
  let s:MPT._prompt.begin = s:complete_input_history(s:complete_input_history_base, s:complete_input_history_num)
  normal! "_ggdG
  call s:MPT._handle_fly(s:MPT._prompt.begin . s:MPT._prompt.cursor .s:MPT._prompt.end)
endfunction

function! s:next_match_history() abort

  if s:complete_input_history_num == [0,0]
    let s:complete_input_history_base = s:MPT._prompt.begin
    let s:MPT._prompt.cursor = ''
    let s:MPT._prompt.end = ''
  else
    let s:MPT._prompt.begin = s:complete_input_history_base
  endif
  let s:complete_input_history_num[1] += 1
  let s:MPT._prompt.begin = s:complete_input_history(s:complete_input_history_base, s:complete_input_history_num)
  normal! "_ggdG
  call s:MPT._handle_fly(s:MPT._prompt.begin . s:MPT._prompt.cursor .s:MPT._prompt.end)
endfunction

function! s:complete_input_history(str,num) abort
  let results = filter(copy(s:grep_history), "v:val =~# '^' . a:str")
  if len(results) > 0
    call add(results, a:str)
    let index = ((len(results) - 1) - a:num[0] + a:num[1]) % len(results)
    return results[index]
  else
    return a:str
  endif
endfunction
let s:MPT._function_key = {
      \ "\<Tab>" : function('s:next_item'),
      \ "\<C-j>" : function('s:next_item'),
      \ "\<ScrollWheelDown>" : function('s:next_item'),
      \ "\<S-tab>" : function('s:previous_item'),
      \ "\<C-k>" : function('s:previous_item'),
      \ "\<ScrollWheelUp>" : function('s:previous_item'),
      \ "\<Return>" : function('s:open_item'),
      \ "\<LeftMouse>" : function('s:move_cursor'),
      \ "\<2-LeftMouse>" : function('s:double_click'),
      \ "\<C-f>" : function('s:start_filter'),
      \ "\<C-r>" : function('s:start_replace'),
      \ "\<C-p>" : function('s:toggle_preview'),
      \ "\<C-e>" : function('s:toggle_expr_mode'),
      \ "\<Up>" : function('s:previous_match_history'),
      \ "\<Down>" : function('s:next_match_history'),
      \ "\<PageDown>" : function('s:page_down'),
      \ "\<PageUp>" : function('s:page_up'),
      \ "\<C-End>" : function('s:page_end'),
      \ "\<C-Home>" : function('s:page_home'),
      \ }

if has('nvim')
  call extend(s:MPT._function_key, 
        \ {
        \ "\x80\xfdJ" : function('s:previous_item'),
        \ "\x80\xfc \x80\xfdJ" : function('s:previous_item'),
        \ "\x80\xfc@\x80\xfdJ" : function('s:previous_item'),
        \ "\x80\xfc`\x80\xfdJ" : function('s:previous_item'),
        \ "\x80\xfdK" : function('s:next_item'),
        \ "\x80\xfc \x80\xfdK" : function('s:next_item'),
        \ "\x80\xfc@\x80\xfdK" : function('s:next_item'),
        \ "\x80\xfc`\x80\xfdK" : function('s:next_item'),
        \ }
        \ )
endif
" }}}

" Public API: SpaceVim#plugins#flygrep#open(argv) {{{

" keys:
" files: files for grep, @buffers means listed buffer.
" dir: specific a directory for grep
function! SpaceVim#plugins#flygrep#open(agrv) abort
  if empty(s:grep_default_exe)
    call SpaceVim#logger#warn(' [flygrep] make sure you have one search tool in your PATH', 1)
    return
  endif
  let s:mode = ''
  " set default handle func: s:flygrep
  let s:MPT._handle_fly = function('s:flygrep')
  noautocmd rightbelow split __flygrep__
  let s:flygrep_buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  let save_tve = &t_ve
  setlocal t_ve=
  " setlocal nomodifiable
  setf SpaceVimFlyGrep
  call s:matchadd('FileName', '[^:]*:\d\+:\d\+:', 3)
  let s:MPT._prompt.begin = get(a:agrv, 'input', '')
  let fs = get(a:agrv, 'files', '')
  if fs ==# '@buffers'
    let s:grep_files = map(s:BUFFER.listed_buffers(), 'bufname(v:val)')
  elseif !empty(fs)
    let s:grep_files = fs
  else
    let s:grep_files = ''
  endif
  let dir = expand(get(a:agrv, 'dir', ''))
  if !empty(dir) && isdirectory(dir)
    let s:grep_dir = dir
  else
    let s:grep_dir = ''
  endif
  let s:grep_exe = get(a:agrv, 'cmd', s:grep_default_exe)
  let s:grep_opt = get(a:agrv, 'opt', s:grep_default_opt)
  let s:grep_ropt = get(a:agrv, 'ropt', s:grep_default_ropt)
  let s:grep_ignore_case = get(a:agrv, 'ignore_case', s:grep_default_ignore_case)
  let s:grep_smart_case  = get(a:agrv, 'smart_case', s:grep_default_smart_case)
  let s:grep_expr_opt  = get(a:agrv, 'expr_opt', s:grep_default_expr_opt)
  call SpaceVim#logger#info('FlyGrep startting ===========================')
  call SpaceVim#logger#info('   executable    : ' . s:grep_exe)
  call SpaceVim#logger#info('   option        : ' . string(s:grep_opt))
  call SpaceVim#logger#info('   r_option      : ' . string(s:grep_ropt))
  call SpaceVim#logger#info('   files         : ' . string(s:grep_files))
  call SpaceVim#logger#info('   dir           : ' . string(s:grep_dir))
  call SpaceVim#logger#info('   ignore_case   : ' . string(s:grep_ignore_case))
  call SpaceVim#logger#info('   smart_case    : ' . string(s:grep_smart_case))
  call SpaceVim#logger#info('   expr opt      : ' . string(s:grep_expr_opt))
  call s:MPT.open()
  call SpaceVim#logger#info('FlyGrep ending    ===========================')
  let &t_ve = save_tve
endfunction
" }}}

" Plugin API: SpaceVim#plugins#flygrep#lineNr() {{{
function! SpaceVim#plugins#flygrep#lineNr() abort
  if getline(1) ==# ''
    return 'no results'
  else
    return line('.') . '/' . line('$')
  endif
endfunction

function! SpaceVim#plugins#flygrep#mode() abort
  return s:grep_mode . (empty(s:mode) ? '' : '(' . s:mode . ')')
endfunction

" }}}
