"=============================================================================
" runner.vim --- code runner for SpaceVim
" Copyright (c) 2016-2022 Wang Shidong & Contributors
" Author: Shidong Wang < wsdjeg@outlook.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================

""
" @section runner, plugins-runner
" @parentsection plugins
" The `code runner` plugin provides the ability to run code snippet or code
" file for a variety of programming languages, as well as running custom commands. 
" 
" @subsection Key bindings
" >
"   Key binding     Description
"   SPC s r         start default code runner
"   q               close coder runner window
"   i               insert text to background process
" <

let s:runners = {}

let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:STRING = SpaceVim#api#import('data#string')
let s:FILE = SpaceVim#api#import('file')
let s:VIM = SpaceVim#api#import('vim')
let s:SYS = SpaceVim#api#import('system')
let s:ICONV = SpaceVim#api#import('iconv')

let s:LOGGER =SpaceVim#logger#derive('runner')

" use code runner buffer for tab
"
"

" the buffer number of code runner
let s:code_runner_bufnr = 0
" @fixme win_getid requires vim 7.4.1557
let s:winid = -1
let s:target = ''
let s:runner_lines = 0
let s:runner_jobid = 0
let s:runner_status = {
      \ 'is_running' : 0,
      \ 'has_errors' : 0,
      \ 'exit_code' : 0
      \ }


let s:task_status = {}
let s:task_stdout = {}
let s:task_stderr = {}
let s:task_problem_matcher = {}

function! s:open_win() abort
  if s:code_runner_bufnr !=# 0 && bufexists(s:code_runner_bufnr) && index(tabpagebuflist(), s:code_runner_bufnr) !=# -1
    return
  endif
  botright split __runner__
  let lines = &lines * 30 / 100
  exe 'resize ' . lines
  setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile nowrap cursorline nospell nonu norelativenumber winfixheight nomodifiable
  set filetype=SpaceVimRunner
  nnoremap <silent><buffer> q :call <SID>close()<cr>
  nnoremap <silent><buffer> i :call <SID>insert()<cr>
  nnoremap <silent><buffer> <C-c> :call <SID>stop_runner()<cr>
  augroup spacevim_runner
    autocmd!
    autocmd BufWipeout <buffer> call <SID>stop_runner()
  augroup END
  let s:code_runner_bufnr = bufnr('%')
  if exists('*win_getid')
    let s:winid = win_getid(winnr())
  endif
  if !g:spacevim_code_runner_focus
    wincmd p
  endif
endfunction

function! s:insert() abort
  call inputsave()
  let input = input('input >')
  if !empty(input) && s:runner_status.is_running == 1
    call s:JOB.send(s:runner_jobid, input)
  endif
  normal! :
  call inputrestore()
endfunction

function! s:async_run(runner, ...) abort
  if type(a:runner) == type('')
    " the runner is a string, the %s will be replaced as a file name.
    try
      let cmd = printf(a:runner, get(s:, 'selected_file', bufname('%')))
    catch
      let cmd = a:runner
    endtry
    call s:LOGGER.info('   cmd:' . string(cmd))
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , -1, 0, ['[Running] ' . cmd, '', repeat('-', 20)])
    let s:runner_lines += 3
    let s:start_time = reltime()
    let opts = get(a:000, 0, {})
    let s:runner_jobid =  s:JOB.start(cmd,extend({
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ }, opts))
  elseif type(a:runner) ==# type([]) && len(a:runner) ==# 2
    " the runner is a list with two items
    " the first item is compile cmd, and the second one is running cmd.

    let s:target = s:FILE.unify_path(tempname(), ':p')
    let dir = fnamemodify(s:target, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
    if type(a:runner[0]) == type({})
      if type(a:runner[0].exe) == type(function('tr'))
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
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , -1, 0, [
          \ '[Compile] ' . compile_cmd_info,
          \ '[Running] ' . s:target,
          \ '',
          \ repeat('-', 20)])
    let s:runner_lines += 4
    let s:start_time = reltime()
    if type(compile_cmd) == type('') || (type(compile_cmd) == type([]) && executable(get(compile_cmd, 0, '')))
      let s:runner_jobid =  s:JOB.start(compile_cmd,{
            \ 'on_stdout' : function('s:on_stdout'),
            \ 'on_stderr' : function('s:on_stderr'),
            \ 'on_exit' : function('s:on_compile_exit'),
            \ })
      if usestdin && s:runner_jobid > 0
        let range = get(a:runner[0], 'range', [1, '$'])
        call s:JOB.send(s:runner_jobid, call('getline', range))
        call s:JOB.chanclose(s:runner_jobid, 'stdin')
      endif
    else
      let exe = get(compile_cmd, 0, '')
      call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , -1, 0, [exe . ' is not executable, make sure ' . exe . ' is in your PATH'])
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
    if type(a:runner.exe) == type(function('tr'))
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
    call s:LOGGER.info('   cmd:' . string(cmd))
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , -1, 0, ['[Running] ' . join(cmd) . (usestdin ? ' STDIN' : ''), '', repeat('-', 20)])
    let s:runner_lines += 3
    let s:start_time = reltime()
    if !empty(exe) && executable(exe[0])
      let s:runner_jobid =  s:JOB.start(cmd,{
            \ 'on_stdout' : function('s:on_stdout'),
            \ 'on_stderr' : function('s:on_stderr'),
            \ 'on_exit' : function('s:on_exit'),
            \ })
      if usestdin && s:runner_jobid > 0
        let range = get(a:runner, 'range', [1, '$'])
        call s:JOB.send(s:runner_jobid, call('getline', range))
        call s:JOB.chanclose(s:runner_jobid, 'stdin')
      endif
    else
      call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , -1, 0, [exe[0] . ' is not executable, make sure ' . exe[0] . ' is in your PATH'])
    endif
  endif
  if s:runner_jobid > 0
    let s:runner_status = {
          \ 'is_running' : 1,
          \ 'has_errors' : 0,
          \ 'exit_code' : 0
          \ }
  endif
endfunction

function! s:on_compile_exit(id, data, event) abort
  if a:id !=# s:runner_jobid
    " make sure the compile exit callback is for current compile command.
    return
  endif
  if a:data == 0
    let s:runner_jobid =  s:JOB.start(s:target,{
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ })
    if s:runner_jobid > 0
      let s:runner_status = {
            \ 'is_running' : 1,
            \ 'has_errors' : 0,
            \ 'exit_code' : 0
            \ }
    endif
  else
    let s:end_time = reltime(s:start_time)
    let s:runner_status.is_running = 0
    let s:runner_status.exit_code = a:data
    let done = ['', '[Done] exited with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds']
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , s:runner_lines + 1, 0, done)
  endif
  call s:update_statusline()
endfunction

function! s:update_statusline() abort
  redrawstatus!
endfunction

function! SpaceVim#plugins#runner#reg_runner(ft, runner) abort
  let s:runners[a:ft] = a:runner
  let desc = printf('%-10S', a:ft) . string(a:runner)
  let cmd = "call SpaceVim#plugins#runner#set_language('" . a:ft . "')"
  call add(g:unite_source_menu_menus.RunnerLanguage.command_candidates, [desc,cmd])
endfunction

function! SpaceVim#plugins#runner#get(ft) abort
  return deepcopy(get(s:runners, a:ft , ''))
endfunction

" this func should support specific a runner
" the runner can be a string
function! SpaceVim#plugins#runner#open(...) abort
  call s:stop_runner()
  let s:runner_jobid = 0
  let s:runner_lines = 0
  let s:runner_status = {
        \ 'is_running' : 0,
        \ 'has_errors' : 0,
        \ 'exit_code' : 0
        \ }
  let s:selected_language = &filetype
  let runner = get(a:000, 0, get(s:runners, s:selected_language, ''))
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
function! s:on_stdout(job_id, data, event) abort
  if a:job_id !=# s:runner_jobid
    " that means, a new runner has been opennd
    " this is previous runner exit_callback
    return
  endif
  if bufexists(s:code_runner_bufnr)
    if s:SYS.isWindows
      let data = map(a:data, 'substitute(v:val, "\r$", "", "g")')
    else
      let data = a:data
    endif
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , s:runner_lines + 1, 0, data)
    let s:runner_lines += len(data)
    if s:winid >= 0
      call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:code_runner_bufnr), 1])
    endif
    call s:update_statusline()
  endif
endfunction

function! s:on_stderr(job_id, data, event) abort
  if a:job_id !=# s:runner_jobid
    " that means, a new runner has been opennd
    " this is previous runner exit_callback
    return
  endif
  let s:runner_status.has_errors = 1
  if bufexists(s:code_runner_bufnr)
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , s:runner_lines + 1, 0, a:data)
  endif
  let s:runner_lines += len(a:data)
  if s:winid >= 0
    call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:code_runner_bufnr), 1])
  endif
  call s:update_statusline()
endfunction

function! s:on_exit(job_id, data, event) abort
  if a:job_id !=# s:runner_jobid
    " that means, a new runner has been opennd
    " this is previous runner exit_callback
    return
  endif
  let s:end_time = reltime(s:start_time)
  let s:runner_status.is_running = 0
  let s:runner_status.exit_code = a:data
  let done = ['', '[Done] exited with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(s:end_time)) . ' seconds']
  if bufexists(s:code_runner_bufnr)
    call s:BUFFER.buf_set_lines(s:code_runner_bufnr, s:runner_lines , s:runner_lines + 1, 0, done)
    call s:VIM.win_set_cursor(s:winid, [s:VIM.buf_line_count(s:code_runner_bufnr), 1])
    call s:update_statusline()
  endif
endfunction
" @vimlint(EVL103, 0, a:job_id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)


function! SpaceVim#plugins#runner#status() abort
  let running_nr = len(filter(values(s:task_status), 'v:val.is_running')) + s:runner_status.is_running
  let running_done = len(filter(values(s:task_status), '!v:val.is_running'))
  return printf(' %s running, %s done', running_nr, running_done)
endfunction

function! s:close() abort
  call s:stop_runner()
  if s:code_runner_bufnr != 0 && bufexists(s:code_runner_bufnr)
    exe 'bd ' s:code_runner_bufnr
  endif
endfunction

function! s:stop_runner() abort
  if s:runner_status.is_running == 1
    call s:JOB.stop(s:runner_jobid)
  endif
endfunction

function! SpaceVim#plugins#runner#select_file() abort
  let s:runner_lines = 0
  let s:runner_status = {
        \ 'is_running' : 0,
        \ 'is_exit' : 0,
        \ 'has_errors' : 0,
        \ 'exit_code' : 0
        \ }
  let s:selected_file = browse(0,'select a file to run', getcwd(), '')
  let runner = get(a:000, 0, get(s:runners, &filetype, ''))
  let s:selected_language = &filetype
  if !empty(runner)
    call s:LOGGER.info('Code runner startting:')
    call s:LOGGER.info('selected file :' . s:selected_file)
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
  if SpaceVim#layers#isLoaded('denite')
    Denite menu:RunnerLanguage
  elseif SpaceVim#layers#isLoaded('leaderf')
    Leaderf menu --name RunnerLanguage
  endif
endfunction

function! SpaceVim#plugins#runner#set_language(lang) abort
  " @todo use denite or unite to select language
  " and set the s:selected_language
  " the all language is keys(s:runners)
  let s:selected_language = a:lang
endfunction


function! SpaceVim#plugins#runner#run_task(task) abort
  let isBackground = get(a:task, 'isBackground', 0)
  if !empty(a:task)
    let cmd = get(a:task, 'command', '') 
    let args = get(a:task, 'args', [])
    let opts = get(a:task, 'options', {})
    if !empty(args) && !empty(cmd)
      let cmd = cmd . ' ' . join(args, ' ')
    endif
    let opt = {}
    if !empty(opts) && has_key(opts, 'cwd') && !empty(opts.cwd)
      call extend(opt, {'cwd' : opts.cwd})
    endif
    if !empty(opts) && has_key(opts, 'env') && !empty(opts.env)
      call extend(opt, {'env' : opts.env})
    endif
    let problemMatcher = get(a:task, 'problemMatcher', {})
    if isBackground
      call s:run_backgroud(cmd, opt, problemMatcher)
    else
      call SpaceVim#plugins#runner#open(cmd, opt, problemMatcher) 
    endif
  endif
endfunction

function! s:match_problems(output, matcher) abort
  if has_key(a:matcher, 'pattern')
    let pattern = a:matcher.pattern
    let items = []
    for line in a:output
      let rst = matchlist(line, pattern.regexp)
      let file = get(rst, get(pattern, 'file', 1), '')
      let line = get(rst, get(pattern, 'line', 2), 1)
      let column = get(rst, get(pattern, 'column', 3), 1)
      let message = get(rst, get(pattern, 'message', 4), '')
      if !empty(file)
        call add(items, {
              \ 'filename' : file,
              \ 'lnum' : line,
              \ 'col' : column,
              \ 'text' : message,
              \ })
      endif
    endfor
    call setqflist([], 'r', {'title' : ' task output',
          \ 'items' : items,
          \ })
    copen
    copen
  else
    try
      let olderrformat = &errorformat
      if has_key(a:matcher, 'errorformat')
        let &errorformat = a:matcher.errorformat
        let cmd = 'noautocmd cexpr a:output'
        exe cmd
        call setqflist([], 'a', {'title' : ' task output'})
        copen
      endif
    finally
      let &errorformat = olderrformat
    endtry
  endif
endfunction

function! s:on_backgroud_stdout(job_id, data, event) abort
  let data = get(s:task_stdout, 'task' . a:job_id, []) + a:data
  let s:task_stdout['task' . a:job_id] = data
endfunction

function! s:on_backgroud_stderr(job_id, data, event) abort
  let data = get(s:task_stderr, 'task' . a:job_id, []) + a:data
  let s:task_stderr['task' . a:job_id] = data
endfunction

function! s:on_backgroud_exit(job_id, data, event) abort
  let task_status = get(s:task_status, 'task' . a:job_id, { 
        \ 'is_running' : 0,
        \ 'has_errors' : 0,
        \ 'start_time' : 0,
        \ 'exit_code' : 0
        \ })
  let end_time = reltime(task_status.start_time)
  let task_problem_matcher = get(s:task_problem_matcher, 'task' . a:job_id, {})
  if get(task_problem_matcher, 'useStdout', 0)
    let output = get(s:task_stdout, 'task' . a:job_id, [])
  else
    let output = get(s:task_stderr, 'task' . a:job_id, [])
  endif
  if !empty(task_problem_matcher) && !empty(output)
    call s:match_problems(output, task_problem_matcher)
  endif
  echo 'task finished with code=' . a:data . ' in ' . s:STRING.trim(reltimestr(end_time)) . ' seconds'
endfunction

function! s:run_backgroud(cmd, ...) abort
  " how many tasks are running?
  "
  " echo 'tasks: 1 running, 2 done'
  let running_nr = len(filter(values(s:task_status), 'v:val.is_running')) + 1
  let running_done = len(filter(values(s:task_status), '!v:val.is_running'))
  echo printf('tasks: %s running, %s done', running_nr, running_done)
  let opts = get(a:000, 0, {})
  " this line can not be removed.
  let s:start_time = reltime()
  let start_time = reltime()
  let problemMatcher = get(a:000, 1, {})
  if !has_key(problemMatcher, 'errorformat') && !has_key(problemMatcher, 'regexp')
    call extend(problemMatcher, {'errorformat' : &errorformat})
  endif
  let task_id = s:JOB.start(a:cmd,extend({
        \ 'on_stdout' : function('s:on_backgroud_stdout'),
        \ 'on_exit' : function('s:on_backgroud_exit'),
        \ }, opts))
  call extend(s:task_problem_matcher, {'task' . task_id : problemMatcher})
  call extend(s:task_status, {'task' . task_id : { 
        \ 'is_running' : 1,
        \ 'has_errors' : 0,
        \ 'start_time' : start_time,
        \ 'exit_code' : 0
        \ }})
endfunction

function! SpaceVim#plugins#runner#clear_tasks() abort
  for taskid in keys(s:task_status)
    if s:task_status[taskid].is_running ==# 1
      call remove(s:task_status, taskid)
    endif
  endfor
endfunction
