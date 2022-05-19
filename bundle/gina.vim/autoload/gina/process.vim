let s:Job = vital#gina#import('System.Job')
let s:Guard = vital#gina#import('Vim.Guard')
let s:String = vital#gina#import('Data.String')

let s:t_dict = type({})
let s:no_askpass_commands = [
      \ 'init',
      \ 'config',
      \]
let s:runnings = {}


function! gina#process#runnings() abort
  return items(s:runnings)
endfunction

function! gina#process#register(job, ...) abort
  if get(a:000, 0, 0)
    let s:runnings['pseudo:' . a:job] = a:job
    call gina#core#emitter#emit('process:registered:pseudo', a:job)
  else
    let s:runnings['job:' . a:job.pid()] = a:job
    call gina#core#emitter#emit('process:registered', a:job.pid(), a:job.params.scheme, a:job.args)
  endif
endfunction

function! gina#process#unregister(job, ...) abort
  if get(a:000, 0, 0)
    silent! unlet s:runnings['pseudo:' . a:job]
    call gina#core#emitter#emit('process:unregistered:pseudo', a:job)
  else
    silent! unlet s:runnings['job:' . a:job.pid()]
    call gina#core#emitter#emit('process:unregistered', a:job.pid(), a:job.params.scheme, a:job.args)
  endif
endfunction

function! gina#process#wait(...) abort
  let timeout = get(a:000, 0, v:null)
  let timeout = timeout is# v:null ? v:null : timeout / 1000.0
  let start_time = reltime()
  let updatetime = g:gina#process#updatetime . 'm'
  call gina#core#emitter#emit('wait:start')
  while timeout is# v:null || timeout > reltimefloat(reltime(start_time))
    if empty(s:runnings)
      call gina#core#emitter#emit('wait:end')
      return
    endif
    execute 'sleep' updatetime
  endwhile
  call gina#core#emitter#emit('wait:timeout')
  return -1
endfunction

function! gina#process#open(git, args, ...) abort
  let args = type(a:args) == s:t_dict ? a:args : gina#core#args#raw(a:args)
  let pipe = extend(gina#process#pipe#default(), get(a:000, 0, {}))
  let pipe.params = get(args, 'params', {})
  let pipe.params.scheme = get(pipe.params, 'scheme', args.get(0, ''))
  let LC_ALL_saved = exists('$LC_ALL') ? $LC_ALL : v:null
  let GIT_EDITOR_saved = exists('$GIT_EDITOR') ? $GIT_EDITOR : v:null
  try
    let $LC_ALL = 'C'
    unlet $GIT_EDITOR
    let job = s:Job.start(s:build_raw_args(a:git, args), pipe)
  finally
    if LC_ALL_saved is# v:null
      unlet $LC_ALL
    else
      let $LC_ALL = LC_ALL_saved
    endif
    if GIT_EDITOR_saved is# v:null
      unlet $GIT_EDITOR
    else
      let $GIT_EDITOR = GIT_EDITOR_saved
    endif
  endtry
  call job.on_start()
  call gina#core#console#debug(printf('process: %s', join(job.args)))
  return job
endfunction

function! gina#process#call(git, args, ...) abort
  let options = extend({
        \ 'timeout': g:gina#process#timeout,
        \}, get(a:000, 0, {})
        \)
  let pipe = gina#process#pipe#store()
  let job = gina#process#open(a:git, a:args, pipe)
  let status = job.wait(options.timeout)
  return {
        \ 'args': job.args,
        \ 'status': status,
        \ 'stdout': pipe.stdout,
        \ 'stderr': pipe.stderr,
        \ 'content': pipe.content,
        \}
endfunction

function! gina#process#call_or_fail(git, args, ...) abort
  let result = call('gina#process#call', [a:git, a:args] + a:000)
  if result.status
    throw gina#process#errormsg(result)
  endif
  return result
endfunction

function! gina#process#inform(result) abort
  redraw | echo
  if a:result.status
    call gina#core#console#warn('Fail: ' . join(a:result.args))
  endif
  call gina#core#console#echo(s:String.remove_ansi_sequences(
        \ join(a:result.content, "\n"))
        \)
endfunction

function! gina#process#errormsg(result) abort
  return gina#core#revelator#error(printf(
        \ "Fail: %s\n%s",
        \ join(a:result.args),
        \ join(a:result.content, "\n")
        \))
endfunction

function! gina#process#build_raw_args(git, args) abort
  return s:build_raw_args(a:git, a:args)
endfunction


" Private --------------------------------------------------------------------
function! s:build_raw_args(git, args) abort
  let args = gina#core#args#raw(g:gina#process#command).raw
  if !empty(a:git) && isdirectory(a:git.worktree)
    call extend(args, ['-C', a:git.worktree])
  endif
  call extend(args, a:args.raw)
  call filter(map(args, 's:expand(v:val)'), '!empty(v:val)')
  " Assign env GIT_TERMINAL_PROMPT/GIT_ASKPASS if necessary
  if index(s:no_askpass_commands, a:args.get(0)) == -1
    call gina#core#askpass#wrap(a:git, args)
  endif
  return args
endfunction

function! s:expand(value) abort
  if a:value =~# '^\%([%#]\|<\w\+>\)\%(:[p8~.htreS]\|:g\?s?\S\+?\S\+?\)*$'
    return gina#core#path#expand(a:value)
  endif
  return a:value
endfunction


call gina#config(expand('<sfile>'), {
      \ 'command': 'git --no-pager -c core.editor=false -c color.status=always',
      \ 'updatetime': 100,
      \ 'timeout': 10000,
      \})
