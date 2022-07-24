" dispatch.vim job strategy

if exists('g:autoloaded_dispatch_job')
  finish
endif
let g:autoloaded_dispatch_job = 1

if !exists('s:waiting')
  let s:waiting = {}
endif

let g:dispatch_waiting_jobs = s:waiting

function! dispatch#job#handle(request) abort
  if !get(g:, 'dispatch_experimental', 1)
    return 0
  endif
  if a:request.action !=# 'make'
    return 0
  endif
  if exists('*job_start')
    if has('win32')
      let cmd = &shell . ' ' . &shellcmdflag . ' ' . dispatch#windows#escape(a:request.expanded)
    else
      let cmd = split(&shell) + split(&shellcmdflag) + [a:request.expanded]
    endif
    let job = job_start(cmd, {
          \ 'mode': 'raw',
          \ 'callback': function('s:output'),
          \ 'close_cb': function('s:closed'),
          \ 'exit_cb': function('s:exit'),
          \ })
    call ch_close_in(job)
    let a:request.pid = job_info(job).process
    let a:request.job = job
    let ch_id = ch_info(job_info(job).channel).id
    let s:waiting[ch_id] = {'request': a:request, 'output': ['']}
  elseif exists('*jobpid') && exists('*jobstart')
    let job_id = jobstart(a:request.expanded, {
          \ 'on_stdout': function('s:output'),
          \ 'on_stderr': function('s:output'),
          \ 'on_exit': function('s:complete'),
          \ })
    call chanclose(job_id, 'stdin')
    let a:request.pid = jobpid(job_id)
    let a:request.job = job_id
    let s:waiting[job_id] = {'request': a:request, 'output': ['']}
  else
    return 0
  endif
  let a:request.handler = 'job'
  call writefile([], a:request.file)
  call writefile([a:request.pid], a:request.file . '.pid')
  return 2
endfunction

function! s:complete(id, status, ...) abort
  let waiting = remove(s:waiting, a:id)
  call writefile([a:status], waiting.request.file . '.complete')
  call DispatchComplete(waiting.request.id)
endfunction

function! s:closed(ch) abort
  let id = ch_info(a:ch).id
  if has_key(s:waiting, id) && has_key(s:waiting[id], 'exit_status')
    call s:complete(id, s:waiting[id].exit_status)
  endif
endfunction

function! s:exit(job, status) abort
  let ch = job_info(a:job).channel
  let info = ch_info(ch)
  if info.status ==# 'closed'
    return s:complete(info.id, a:status)
  else
    let s:waiting[info.id].exit_status = a:status
  endif
endfunction

function! s:output(ch, output, ...) abort
  if a:0
    " nvim
    let waiting = s:waiting[a:ch]
    let output = a:output
  else
    " vim
    let waiting = s:waiting[ch_info(a:ch).id]
    let output = split(a:output, "\n", 1)
  endif
  let request = waiting.request
  call writefile(output, request.file, 'ab')
  let waiting.output[-1] .= remove(output, 0)
  call extend(waiting.output, output)

  if dispatch#request(get(getqflist({'title': 1}), 'title', '')) is# request && len(waiting.output) > 1
    let lefm = &l:efm
    let gefm = &g:efm
    let makeprg = &l:makeprg
    let compiler = get(b:, 'current_compiler', '')
    let cd = exists('*haslocaldir') && haslocaldir() ? 'lcd' : exists(':tcd') && haslocaldir(-1) ? 'tcd' : 'cd'
    let dir = getcwd()
    let modelines = &modelines
    try
      let &modelines = 0
      let b:current_compiler = get(request, 'compiler', '')
      if empty(b:current_compiler)
        unlet! b:current_compiler
      endif
      exe cd fnameescape(request.directory)
      let &l:efm = request.format
      let &g:efm = request.format
      let &l:makeprg = request.command
      caddexpr remove(waiting.output, 0, -2)
    finally
      let &modelines = modelines
      exe cd fnameescape(dir)
      let &l:efm = lefm
      let &g:efm = gefm
      let &l:makeprg = makeprg
      if empty(compiler)
        unlet! b:current_compiler
      else
        let b:current_compiler = compiler
      endif
    endtry
    cbottom
  endif
endfunction

function! dispatch#job#kill(pid, force) abort
  let request = dispatch#request('job/' . a:pid)
  if exists('*job_stop')
    return job_stop(request.job, a:force ? 'kill' : 'hup')
  elseif exists('*jobstop')
    call jobstop(request.job)
    return 1
  endif
endfunction

function! dispatch#job#activate(pid) abort
  return 0
endfunction
