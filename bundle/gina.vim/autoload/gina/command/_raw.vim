function! gina#command#_raw#call(range, args, mods) abort
  let git = gina#core#get()
  let args = s:build_args(git, a:args)
  let pipe = a:mods =~# '\<silent\>'
        \ ? deepcopy(s:pipe_silent)
        \ : deepcopy(s:pipe)
  return gina#process#open(git, args, pipe)
endfunction

function! gina#command#_raw#complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(1))
    return gina#complete#common#raw_command(a:arglead, a:cmdline, a:cursorpos)
  endif
  if args.get(1) =~# '^\%(fetch\|pull\|push\|switch\)$'
    return s:{args.get(1)}_complete(a:arglead, a:cmdline, a:cursorpos)
  endif
  return []
endfunction


" Private --------------------------------------------------------------------
function! s:build_args(git, args) abort
  let args = a:args.clone()
  if args.get(0) ==# '_raw'
    " Remove leading '_raw' if exists
    call args.pop(0)
  endif
  return args.lock()
endfunction

function! s:fetch_complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(2))
    return gina#complete#common#remote(a:arglead, a:cmdline, a:cursorpos)
  endif
  if empty(args.get(3))
    " TODO: Return refspecs in remote repository "args.get(2)".
  endif
  return []
endfunction

function! s:pull_complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(2))
    return gina#complete#common#remote(a:arglead, a:cmdline, a:cursorpos)
  endif
  if empty(args.get(3))
    " TODO: Return refspecs in remote repository "args.get(2)".
  endif
  return []
endfunction

function! s:push_complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(2))
    return gina#complete#common#remote(a:arglead, a:cmdline, a:cursorpos)
  endif
  if empty(args.get(3))
    return gina#complete#commit#local_branch(a:arglead, a:cmdline, a:cursorpos)
  endif
  return []
endfunction

function! s:switch_complete(arglead, cmdline, cursorpos) abort
  let args = gina#core#args#new(matchstr(a:cmdline, '^.*\ze .*'))
  if empty(args.get(2))
    return gina#complete#commit#local_branch(a:arglead, a:cmdline, a:cursorpos)
  endif
  return []
endfunction


" Pipe -----------------------------------------------------------------------
function! s:_pipe_on_exit(exitval) abort dict
  call call(s:original_pipe.on_exit, [a:exitval], self)
  call gina#core#emitter#emit(
        \ 'command:called:raw',
        \ self.params.scheme,
        \)
endfunction

function! s:_pipe_silent_on_exit(exitval) abort dict
  call call(s:original_pipe_silent.on_exit, [a:exitval], self)
  call gina#core#emitter#emit(
        \ 'command:called:raw',
        \ self.params.scheme,
        \)
endfunction

let s:original_pipe = gina#process#pipe#echo()
let s:original_pipe_silent = gina#process#pipe#default()
let s:pipe = extend(deepcopy(s:original_pipe), {
      \ 'on_exit': function('s:_pipe_on_exit'),
      \})
let s:pipe_silent = extend(deepcopy(s:original_pipe_silent), {
      \ 'on_exit': function('s:_pipe_silent_on_exit'),
      \})


" Event ----------------------------------------------------------------------
function! s:on_command_called_raw(...) abort
  call gina#core#emitter#emit('modified:delay')
endfunction


if !exists('s:subscribed')
  let s:subscribed = 1
  call gina#core#emitter#subscribe(
        \ 'command:called:raw',
        \ function('s:on_command_called_raw')
        \)
endif
