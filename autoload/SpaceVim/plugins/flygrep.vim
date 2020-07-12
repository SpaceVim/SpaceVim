"=============================================================================
" flygrep.vim --- Grep on the fly in SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

" Loading SpaceVim api {{{
scriptencoding utf-8
let s:MPT = SpaceVim#api#import('prompt')
let s:JOB = SpaceVim#api#import('job')
let s:SYS = SpaceVim#api#import('system')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:LIST = SpaceVim#api#import('data#list')
let s:HI = SpaceVim#api#import('vim#highlight')
let s:FLOATING = SpaceVim#api#import('neovim#floating')
let s:JSON = SpaceVim#api#import('data#json')
let s:SL = SpaceVim#api#import('vim#statusline')
" }}}

let s:grepid = 0

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
let s:preview_timer_id = -1
let s:grepid = 0
function! s:read_histroy() abort
  if filereadable(expand(g:spacevim_data_dir.'/SpaceVim/flygrep_history'))
    let _his = s:JSON.json_decode(join(readfile(expand(g:spacevim_data_dir.'/SpaceVim/flygrep_history'), ''), ''))
    if type(_his) ==# type([])
      return _his
    else
      return []
    endif
  else
    return []
  endif
endfunction
function! s:update_history() abort
  if index(s:grep_history, s:grep_expr) >= 0
    call remove(s:grep_history, index(s:grep_history, s:grep_expr))
  endif
  call add(s:grep_history, s:grep_expr)
  if !isdirectory(expand(g:spacevim_data_dir.'/SpaceVim'))
    call mkdir(expand(g:spacevim_data_dir.'/SpaceVim'))
  endif
  call writefile([s:JSON.json_encode(s:grep_history)], expand(g:spacevim_data_dir.'/SpaceVim/flygrep_history'))
endfunction
let s:grep_history = s:read_histroy()
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
  " sometimes the flygrep command failed to run, so we need to log the jobid
  " of the grep command.
  call SpaceVim#logger#info('flygrep job id is: ' . string(s:grepid))
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
    " grep files is a list, which mean to use flygrep searching in 
    " multiple files
    let cmd += [a:expr] + s:grep_files
  elseif !empty(s:grep_files) && type(s:grep_files) == 1
    " grep file is a single file
    let cmd += [a:expr] + [s:grep_files]
  elseif !empty(s:grep_dir)
    " grep dir is not a empty string
    if s:grep_exe ==# 'findstr'
      let cmd += [s:grep_dir] + [a:expr] + ['%CD%\*']
    else
      let cmd += [a:expr] + [s:grep_dir]
    endif
  else
    " if grep dir is empty, grep files is empty, which means searhing in
    " current directory.
    let cmd += [a:expr] 
    " in window, when using rg, ag, need to add '.' at the end.
    if s:SYS.isWindows && (s:grep_exe ==# 'rg' || s:grep_exe ==# 'ag' || s:grep_exe ==# 'pt' )
      let cmd += ['.']
    endif
    let cmd += s:grep_ropt
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
  if s:grepid != 0
    call s:JOB.stop(s:grepid)
  endif
  let replace_text = s:current_grep_pattern
  if !empty(replace_text)
    let rst = SpaceVim#plugins#iedit#start({'expr' : replace_text}, line('w0'), line('w$'))
  endif
  let s:hi_id = s:matchadd('FlyGrepPattern', s:expr_to_pattern(rst), 2)
  redrawstatus
  if rst !=# replace_text
    call s:update_files(s:flygrep_result_to_files())
    checktime
  endif
endfunction
" }}}

function! s:flygrep_result_to_files() abort
  let files = []
  for line in getbufline(s:flygrep_buffer_id, 1, '$')
    let filename = fnameescape(split(line, ':\d\+:')[0])
    let linenr = matchstr(line, ':\d\+:')[1:-2]
    let str = matchstr(line, '\(:\d\+:\d\+:\)\@<=.*')
    call add(files, [filename, linenr, str])
  endfor
  return files
endfunction

function! s:update_files(files) abort
  let fname = ''
  let lines = {}
  for file in a:files
    if file[0] == fname
      call extend(lines, {file[1] : file[2]})
    else
      if !empty(fname)
        call s:update_file(fname, lines)
      endif
      let fname = file[0]
      let lines = {}
      call extend(lines, {file[1] : file[2]})
    endif
  endfor
  if !empty(fname)
    call s:update_file(fname, lines)
  endif
endfunction

function! s:update_file(fname, lines) abort
  let contents = readfile(a:fname, '')
  for linenr in keys(a:lines)
    let contents[linenr - 1] = a:lines[ linenr ]
  endfor
  call writefile(contents, a:fname, '')
endfunction


" API: MPT._prompt {{{
let s:MPT._prompt.mpt = g:spacevim_commandline_prompt . ' '
" }}}

" API: MPT._onclose {{{
function! s:close_buffer() abort
  " NOTE: the jobid maybe -1, that is means the cmd is not executable.
  if s:grepid > 0
    call s:JOB.stop(s:grepid)
  endif
  call timer_stop(s:grep_timer_id)
  call timer_stop(s:preview_timer_id)
  if s:preview_able == 1
    for id in s:previewd_bufnrs
      try
        exe 'silent bd ' . id
      catch
      endtry
    endfor
    noautocmd pclose
    let s:preview_able = 0
  endif
  noautocmd q
endfunction
let s:MPT._onclose = function('s:close_buffer')
" }}}

" API: MPT._oninputpro {{{
function! s:close_grep_job() abort
  " NOTE: the jobid maybe -1, that is means the cmd is not executable.
  if s:grepid > 0
    try
      call s:JOB.stop(s:grepid)
    catch
    endtry
    let s:std_line = 0
  endif
  call timer_stop(s:grep_timer_id)
  call timer_stop(s:preview_timer_id)
  noautocmd normal! "_ggdG
  call s:update_statusline()
  let s:complete_input_history_num = [0,0]
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

" if exists('*nvim_open_win')
" let s:std_line = 0
" function! s:grep_stdout(id, data, event) abort
" let datas =filter(a:data, '!empty(v:val)')
" call nvim_buf_set_lines(s:buffer_id,s:std_line,-1,v:true,datas)
" let s:std_line += len(datas)
" call s:MPT._build_prompt()
" endfunction
" else
function! s:grep_stdout(id, data, event) abort
  let datas =filter(a:data, '!empty(v:val)')
  " let datas = s:LIST.uniq_by_func(datas, function('s:file_line'))
  if bufnr('%') == s:flygrep_buffer_id
    " You probably split lines by \n, but Windows ses \r\n, so the \r (displayed via ^M) is still left.
    " ag support is broken in windows + neovim-qt
    if getline(1) ==# ''
      call setline(1, datas)
    else
      call append('$', datas)
    endif
  endif
endfunction
" endif

function! s:grep_stderr(id, data, event) abort
  call SpaceVim#logger#error(' flygerp stderr: ' . string(a:data))
endfunction

function! s:grep_exit(id, data, event) abort
  call s:update_statusline()
  redraw
  call s:MPT._build_prompt()
  redrawstatus
  let s:std_line = 1
  let s:grepid = 0
endfunction
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:event)
"}}}

" FlyGrep Key prompt key bindings: {{{
function! s:next_item() abort
  if line('.') == line('$')
    noautocmd normal! gg
  else
    noautocmd normal! j
  endif
  if s:preview_able == 1
    call s:preview()
  endif
  call s:update_statusline()
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_up() abort
  exe "noautocmd normal! \<PageUp>"
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_down() abort
  exe "noautocmd normal! \<PageDown>"
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_home() abort
  noautocmd normal! gg
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:page_end() abort
  noautocmd normal! G
  if s:preview_able == 1
    call s:preview()
  endif
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:previous_item() abort
  if line('.') == 1
    noautocmd normal! G
  else
    noautocmd normal! k
  endif
  if s:preview_able == 1
    call s:preview()
  endif
  call s:update_statusline()
  redraw
  call s:MPT._build_prompt()
  redrawstatus
endfunction

function! s:open_item() abort
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
    if s:preview_able == 1
      pclose
    endif
    let s:preview_able = 0
    noautocmd q
    exe 'silent e ' . filename
    call s:update_history()
    call cursor(linenr, colum)
    noautocmd normal! :
  endif
endfunction

function! s:open_item_vertically() abort
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
    if s:preview_able == 1
      pclose
    endif
    let s:preview_able = 0
    noautocmd q
    exe 'silent vsplit ' . filename
    call s:update_history()
    call cursor(linenr, colum)
    noautocmd normal! :
  endif
endfunction

function! s:open_item_horizontally() abort
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
    if s:preview_able == 1
      pclose
    endif
    let s:preview_able = 0
    noautocmd q
    exe 'silent split ' . filename
    call s:update_history()
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


let s:previewd_bufnrs = []

" @vimlint(EVL103, 1, a:timer)
" use floating windows to preview
let s:preview_win_id = -1
if exists('*nvim_open_win')
  function! s:preview_timer(timer) abort

  endfunction
else
  function! s:preview_timer(timer) abort
    for id in filter(s:previewd_bufnrs, 'bufexists(v:val) && buflisted(v:val)')
      exe 'silent bd ' . id
    endfor
    let br = bufnr('$')
    let line = getline('.')
    let filename = fnameescape(split(line, ':\d\+:')[0])
    let linenr = matchstr(line, ':\d\+:')[1:-2]
    exe 'silent pedit! +' . linenr . ' ' . filename
    wincmd p
    if bufnr('%') > br
      call add(s:previewd_bufnrs, bufnr('%'))
    endif
    wincmd p
    resize 18
    call s:MPT._build_prompt()
  endfunction
endif
" @vimlint(EVL103, 0, a:timer)


function! s:preview() abort
  call timer_stop(s:preview_timer_id)
  let s:preview_timer_id = timer_start(200, function('s:preview_timer'), {'repeat' : 1})
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
  noautocmd normal! "_ggdG
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
  noautocmd normal! "_ggdG
  call s:MPT._handle_fly(s:MPT._prompt.begin . s:MPT._prompt.cursor .s:MPT._prompt.end)
endfunction

function! s:complete_input_history(str,num) abort
  let results = filter(copy(s:grep_history), "v:val =~# '^' . a:str")
  if a:num[0] - a:num[1] == 0
    return a:str
  elseif len(results) > 0
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
      \ "\<C-v>" : function('s:open_item_vertically'),
      \ "\<C-s>" : function('s:open_item_horizontally'),
      \ "\<M-r>" : function('s:start_replace'),
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

let s:MPT._keys.close = ["\<Esc>", "\<C-c>"]
" }}}

" Public API: SpaceVim#plugins#flygrep#open(argv) {{{

" keys:
" files: files for grep, @buffers means listed buffer.
" dir: specific a directory for grep
function! SpaceVim#plugins#flygrep#open(argv) abort
  if empty(s:grep_default_exe)
    call SpaceVim#logger#warn(' [flygrep] make sure you have one search tool in your PATH', 1)
    return
  endif
  let s:mode = ''
  " set default handle func: s:flygrep
  let s:MPT._handle_fly = function('s:flygrep')
  if exists('*nvim_open_win')
    let s:buffer_id = s:BUFFER.create_buf(v:false, v:true)
    let flygrep_win_height = 16
    let s:flygrep_win_id =  s:FLOATING.open_win(s:buffer_id, v:true,
          \ {
          \ 'relative': 'editor',
          \ 'width'   : &columns, 
          \ 'height'  : flygrep_win_height,
          \ 'row': &lines - flygrep_win_height - 2,
          \ 'col': 0
          \ })
  else
    noautocmd rightbelow split __flygrep__
    let s:flygrep_win_id = win_getid()
  endif
  if exists('&winhighlight')
    set winhighlight=Normal:Pmenu,EndOfBuffer:Pmenu,CursorLine:PmenuSel
  endif
  let s:flygrep_buffer_id = bufnr('%')
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber
  let save_tve = &t_ve
  setlocal t_ve=
  let cursor_hi = {}
  if has('gui_running')
    let cursor_hi = s:HI.group2dict('Cursor')
    call s:HI.hide_in_normal('Cursor')
  endif
  " setlocal nomodifiable
  setf SpaceVimFlyGrep
  call s:update_statusline()
  call s:matchadd('FileName', '[^:]*:\d\+:\d\+:', 3)
  let s:MPT._prompt.begin = get(a:argv, 'input', '')
  let fs = get(a:argv, 'files', '')
  if fs ==# '@buffers'
    let s:grep_files = map(s:BUFFER.listed_buffers(), 'bufname(v:val)')
  elseif !empty(fs)
    let s:grep_files = fs
  else
    let s:grep_files = ''
  endif
  let dir = expand(get(a:argv, 'dir', ''))
  if !empty(dir) && isdirectory(dir)
    let s:grep_dir = dir
  else
    let s:grep_dir = ''
  endif
  let s:grep_exe = get(a:argv, 'cmd', s:grep_default_exe)
  if empty(s:grep_dir) && empty(s:grep_files) && s:grep_exe ==# 'findstr'
    let s:grep_files = '*.*'
  elseif s:grep_exe ==# 'findstr' && !empty(s:grep_dir)
    let s:grep_dir = '/D:' . s:grep_dir
  endif
  let s:grep_opt = get(a:argv, 'opt', s:grep_default_opt)
  let s:grep_ropt = get(a:argv, 'ropt', s:grep_default_ropt)
  let s:grep_ignore_case = get(a:argv, 'ignore_case', s:grep_default_ignore_case)
  let s:grep_smart_case  = get(a:argv, 'smart_case', s:grep_default_smart_case)
  let s:grep_expr_opt  = get(a:argv, 'expr_opt', s:grep_default_expr_opt)
  call SpaceVim#logger#info('FlyGrep startting ===========================')
  call SpaceVim#logger#info('   executable    : ' . s:grep_exe)
  call SpaceVim#logger#info('   option        : ' . string(s:grep_opt))
  call SpaceVim#logger#info('   r_option      : ' . string(s:grep_ropt))
  call SpaceVim#logger#info('   files         : ' . string(s:grep_files))
  call SpaceVim#logger#info('   dir           : ' . string(s:grep_dir))
  call SpaceVim#logger#info('   ignore_case   : ' . string(s:grep_ignore_case))
  call SpaceVim#logger#info('   smart_case    : ' . string(s:grep_smart_case))
  call SpaceVim#logger#info('   expr opt      : ' . string(s:grep_expr_opt))
  " sometimes user can not see the flygrep windows, redraw only once.
  redraw
  call s:MPT.open()
  if s:SL.support_float()
    call s:close_statusline()
  endif
  call SpaceVim#logger#info('FlyGrep ending    ===========================')
  let &t_ve = save_tve
  if has('gui_running')
    call s:HI.hi(cursor_hi)
  endif
endfunction
" }}}

function! s:update_statusline() abort
  if !exists('*nvim_open_win')
    return
  endif
  call s:SL.open_float([
        \ ['FlyGrep ', 'SpaceVim_statusline_a_bold'],
        \ [' ', 'SpaceVim_statusline_a_SpaceVim_statusline_b'],
        \ [SpaceVim#plugins#flygrep#mode() . ' ', 'SpaceVim_statusline_b'],
        \ [' ', 'SpaceVim_statusline_b_SpaceVim_statusline_c'],
        \ [getcwd() . ' ', 'SpaceVim_statusline_c'],
        \ [' ', 'SpaceVim_statusline_c_SpaceVim_statusline_b'],
        \ [SpaceVim#plugins#flygrep#lineNr() . ' ', 'SpaceVim_statusline_b'],
        \ [' ', 'SpaceVim_statusline_b_SpaceVim_statusline_z'],
        \ [repeat(' ', &columns - 11), 'SpaceVim_statusline_z'],
        \ ])
endfunction


function! s:close_statusline() abort
  call s:SL.close_float()
endfunction

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
