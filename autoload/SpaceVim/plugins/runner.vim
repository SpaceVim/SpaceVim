"=============================================================================
" runner.vim --- code runner for SpaceVim
" Copyright (c) 2016-2019 Shidong Wang & Contributors
" Author: Shidong Wang < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:STRING = SpaceVim#api#import('data#string')
let s:FILE = SpaceVim#api#import('file')
let s:VIM = SpaceVim#api#import('vim')
let s:SYS = SpaceVim#api#import('system')
let s:ICONV = SpaceVim#api#import('iconv')


let s:runners = {}

let s:bufnr = 0
let s:winid = -1

function! s:open_win() abort
  if s:bufnr != 0 && bufexists(s:bufnr)
    exe 'bd ' . s:bufnr
  endif
  botright split __runner__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist nomodifiable
        \ noswapfile
        \ nowrap
        \ cursorline
        \ nospell
        \ nonu
        \ norelativenumber
        \ winfixheight
        \ nomodifiable
  set filetype=SpaceVimRunner
  nnoremap <silent><buffer> q :call SpaceVim#plugins#runner#close()<cr>
  nnoremap <silent><buffer> i :call <SID>insert()<cr>
  let s:bufnr = bufnr('%')
  let s:winid = win_getid(winnr())
  wincmd p
endfunction

function! s:insert() abort
  call inputsave()
  let input = input('input >')
  if !empty(input) && s:status.is_running == 1
    call s:JOB.send(s:job_id, input)
  endif
  normal! :
  call inputrestore()
endfunction

let s:target = ''

function! s:async_run(runner, ...) abort
  if type(a:runner) == type('')
    " the runner is a string, the %s will be replaced as a file name.
    try
      let cmd = printf(a:runner, get(s:, 'selected_file', bufname('%')))
    catch
      let cmd = a:runner
    endtry
    call SpaceVim#logger#info('   cmd:' . string(cmd))
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 3, 0, ['[Running] ' . cmd, '', repeat('-', 20)])
    let s:lines += 3
    let s:start_time = reltime()
    let opts = get(a:000, 0, {})
    let s:job_id =  s:JOB.start(cmd,extend({
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }, opts))
  elseif type(a:runner) ==# type([]) && len(a:runner) ==# 2
    " the runner is a list with two items
    " the first item is compile cmd, and the second one is running cmd.
    let s:target = s:FILE.unify_path(tempname(), ':p')
    let dir = fnamemodify(s:target, ':h')
    if isdirectory(dir)
      call mkdir(dir, 'p')
    endif
    if type(a:runner[0]) == type({})
      if type(a:runner[0].exe) == 2
        let exe = call(a:runner[0].exe, [])
      elseif type(a:runner[0].exe) ==# type('')
        let exe = [a:runner[0].exe]
      endif
      let usestdin = get(a:runner[0], 'usestdin', 0)
      let compile_cmd = exe + [get(a:runner[0], 'targetopt', '')] + [s:target]
      if usestdin
        let compile_cmd = compile_cmd + a:runner[0].opt
      else
        let compile_cmd = compile_cmd + a:runner[0].opt + [get(s:, 'selected_file', bufname('%'))]
      endif
    elseif type(a:runner[0]) ==# type('')
      let usestdin =  0
      let compile_cmd = substitute(printf(a:runner[0], bufname('%')), '#TEMP#', s:target, 'g')
    endif
    if type(compile_cmd) == type([])
      let compile_cmd_info = string(compile_cmd + (usestdin ? ['STDIN'] : []))
    else
      let compile_cmd_info = compile_cmd . (usestdin ? ' STDIN' : '') 
    endif
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 3, 0, [
          \ '[Compile] ' . compile_cmd_info,
          \ '[Running] ' . s:target,
          \ '',
          \ repeat('-', 20)])
    let s:lines += 4
    let s:start_time = reltime()
    let s:job_id =  s:JOB.start(compile_cmd,{
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_compile_exit'),
          \ })
    if usestdin && s:job_id > 0
      let range = get(a:runner[0], 'range', [1, '$'])
      call s:JOB.send(s:job_id, call('getline', range))
      call s:JOB.chanclose(s:job_id, 'stdin')
    endif
  elseif type(a:runner) == type({})
    " the runner is a dict
    " keys:
    "   exe : function, return a cmd list
    "         string
    "   usestdin: true, use stdin
    "             false, use file name
    "   range: empty, whole buffer
    "          getline(a, b)
    if type(a:runner.exe) == 2
      let exe = call(a:runner.exe, [])
    elseif type(a:runner.exe) ==# type('')
      let exe = [a:runner.exe]
    endif
    let usestdin = get(a:runner, 'usestdin', 0)
    if usestdin
      let cmd = exe + a:runner.opt
    else
      let cmd = exe + a:runner.opt + [get(s:, 'selected_file', bufname('%'))]
    endif
    call SpaceVim#logger#info('   cmd:' . string(cmd))
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 3, 0, ['[Running] ' . join(cmd) . (usestdin ? ' STDIN' : ''), '', repeat('-', 20)])
    let s:lines += 3
    let s:start_time = reltime()
    let s:job_id =  s:JOB.start(cmd,{
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ })
    if usestdin && s:job_id > 0
      let range = get(a:runner, 'range', [1, '$'])
      call s:JOB.send(s:job_id, call('getline', range))
      call s:JOB.chanclose(s:job_id, 'stdin')
    endif
  endif
  if s:job_id > 0
    let s:status = {
          \ 'is_running' : 1,
          \ 'is_exit' : 0,
          \ 'has_errors' : 0,
          \ 'exit_code' : 0
          \ }
  endif
endfunction

" @vimlint(EVL103, 1, a:id)
" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:event)
function! s:on_compile_exit(id, data, event) abort
  if a:data == 0
    let s:job_id =  s:JOB.start(s:target,{
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ })
    if s:job_id > 0
      let s:status = {
            \ 'is_running' : 1,
            \ 'is_exit' : 0,
            \ 'has_errors' : 0,
            \ 'exit_code' : 0
            \ }
    endif
  else
    let s:end_time = reltime(s:start_time)
    let s:status.is_exit = 1
    let s:status.exit_code = a:data
    let done = ['', '[Done] exited with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds']
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, done)
  endif
  call s:update_statusline()
endfunction
" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)

function! s:update_statusline() abort
  redrawstatus!
endfunction

function! SpaceVim#plugins#runner#reg_runner(ft, runner) abort
  let s:runners[a:ft] = a:runner
  let desc = '[' . a:ft . '] ' . string(a:runner)
  let cmd = "call SpaceVim#plugins#runner#set_language('" . a:ft . "')"
  call add(g:unite_source_menu_menus.RunnerLanguage.command_candidates, [desc,cmd])
endfunction

function! SpaceVim#plugins#runner#get(ft) abort
  return deepcopy(get(s:runners, a:ft , ''))
endfunction

" this func should support specific a runner
" the runner can be a string
function! SpaceVim#plugins#runner#open(...) abort
  let s:lines = 0
  let s:status = {
        \ 'is_running' : 0,
        \ 'is_exit' : 0,
        \ 'has_errors' : 0,
        \ 'exit_code' : 0
        \ }
  let runner = get(a:000, 0, get(s:runners, &filetype, ''))
  let opts = get(a:000, 1, {})
  if !empty(runner)
    call s:open_win()
    call s:async_run(runner, opts)
    call s:update_statusline()
  else
    let s:selected_language = get(s:, 'selected_language', '')
  endif
endfunction

" @vimlint(EVL103, 1, a:job_id)
" @vimlint(EVL103, 1, a:data)
" @vimlint(EVL103, 1, a:event)
if has('nvim') && exists('*chanclose')
  " remoet  at the end of each 
  let s:_out_data = ['']
  function! s:on_stdout(job_id, data, event) abort
    let s:_out_data[-1] .= a:data[0]
    call extend(s:_out_data, a:data[1:])
    if s:_out_data[-1] ==# ''
      call remove(s:_out_data, -1)
      let lines = s:_out_data
    else
      let lines = s:_out_data
    endif
    " if s:SYS.isWindows
    " let lines = map(lines, 's:ICONV.iconv(v:val, "cp936", "utf-8")')
    " endif
    if !empty(lines)
      let lines = map(lines, "substitute(v:val, '$', '', 'g')")
      if bufexists(s:bufnr)
        call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, lines)
      endif
      call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:bufnr), 1])
    endif
    let s:lines += len(lines)
    let s:_out_data = ['']
    call s:update_statusline()
  endfunction

  let s:_err_data = ['']
  function! s:on_stderr(job_id, data, event) abort
    let s:_out_data[-1] .= a:data[0]
    call extend(s:_out_data, a:data[1:])
    if s:_out_data[-1] ==# ''
      call remove(s:_out_data, -1)
      let lines = s:_out_data
    else
      let lines = s:_out_data
    endif
    if s:SYS.isWindows
      let lines = map(lines, 's:ICONV.iconv(v:val, "cp936", "utf-8")')
    endif
    if !empty(lines)
      let lines = map(lines, "substitute(v:val, '$', '', 'g')")
      if bufexists(s:bufnr)
        call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, lines)
      endif
      call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:bufnr), 1])
    endif
    let s:lines += len(lines)
    let s:_out_data = ['']
    call s:update_statusline()
  endfunction
else
  function! s:on_stdout(job_id, data, event) abort
    if bufexists(s:bufnr)
      call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, a:data)
    endif
    let s:lines += len(a:data)
    call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:bufnr), 1])
    call s:update_statusline()
  endfunction

  function! s:on_stderr(job_id, data, event) abort
    let s:status.has_errors = 1
    if bufexists(s:bufnr)
      call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, a:data)
    endif
    let s:lines += len(a:data)
    call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:bufnr), 1])
    call s:update_statusline()
  endfunction
endif

function! s:on_exit(job_id, data, event) abort
  let s:end_time = reltime(s:start_time)
  let s:status.is_exit = 1
  let s:status.exit_code = a:data
  let done = ['', '[Done] exited with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds']
  if bufexists(s:bufnr)
    call s:BUFFER.buf_set_lines(s:bufnr, s:lines , s:lines + 1, 0, done)
  endif
  call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:bufnr), 1])
  call s:update_statusline()

endfunction
" @vimlint(EVL103, 0, a:job_id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)

function! s:debug_info() abort
  return []
endfunction


function! SpaceVim#plugins#runner#status() abort
  if s:status.is_running == 1
  elseif s:status.is_exit == 1
    return 'exit code : ' . s:status.exit_code 
          \ . '    time: ' . s:STRING.trim(reltimestr(s:end_time))
          \ . '    language: ' . get(s:, 'selected_language', &ft)
  endif
  return ''
endfunction

function! SpaceVim#plugins#runner#close() abort
  if s:status.is_exit == 0 && s:job_id > 0
    call s:JOB.stop(s:job_id)
  endif
  exe 'bd ' s:bufnr
endfunction

function! SpaceVim#plugins#runner#select_file() abort
  let s:lines = 0
  let s:status = {
        \ 'is_running' : 0,
        \ 'is_exit' : 0,
        \ 'has_errors' : 0,
        \ 'exit_code' : 0
        \ }
  let s:selected_file = browse(0,'select a file to run', getcwd(), '')
  let runner = get(a:000, 0, get(s:runners, &filetype, ''))
  let s:selected_language = &filetype
  if !empty(runner)
    call SpaceVim#logger#info('Code runner startting:')
    call SpaceVim#logger#info('selected file :' . s:selected_file)
    call s:open_win()
    call s:async_run(runner)
    call s:update_statusline()
  endif
endfunction

let g:unite_source_menu_menus =
      \ get(g:,'unite_source_menu_menus',{})
let g:unite_source_menu_menus.RunnerLanguage = {'description':
      \ 'Custom mapped keyboard shortcuts                   [SPC] p p'}
let g:unite_source_menu_menus.RunnerLanguage.command_candidates =
      \ get(g:unite_source_menu_menus.RunnerLanguage,'command_candidates', [])

function! SpaceVim#plugins#runner#select_language() abort
  " @todo use denite or unite to select language
  " and set the s:selected_language
  " the all language is keys(s:runners)
  Denite menu:RunnerLanguage
endfunction

function! SpaceVim#plugins#runner#set_language(lang) abort
  " @todo use denite or unite to select language
  " and set the s:selected_language
  " the all language is keys(s:runners)
  let s:selected_language = a:lang
endfunction


function! SpaceVim#plugins#runner#run_task(task)
  let isBackground = get(a:task, 'isBackground', 0)
  if !empty(a:task)
    let cmd = get(a:task, 'command', '') 
    let args = get(a:task, 'args', [])
    let opts = get(a:task, 'options', {})
    if !empty(args) && !empty(cmd)
      let cmd = cmd . ' ' . join(args, ' ')
    endif
    if !empty(opts) && has_key(opts, 'cwd') && !empty(opts.cwd)
      let opts = {'cwd' : opts.cwd}
    endif
    if isBackground
      call s:run_backgroud(cmd, opts)
    else
      call SpaceVim#plugins#runner#open(cmd, opts) 
    endif
  endif
endfunction

function! s:on_backgroud_exit(job_id, data, event) abort
  let s:end_time = reltime(s:start_time)
  let exit_code = a:data
  echo 'task finished with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds'
endfunction

function! s:run_backgroud(cmd, ...) abort
  echo "task running"
  let opts = get(a:000, 0, {})
  let s:start_time = reltime()
  call s:JOB.start(a:cmd,extend({
        \ 'on_exit' : function('s:on_backgroud_exit'),
        \ }, opts))
endfunction
