let s:String = vital#gina#import('Data.String')
let s:SCHEME = gina#command#scheme(expand('<sfile>'))
let s:current = {
      \ 'bufnr': 0,
      \ 'middleware': {},
      \}


function! gina#command#_events#call(range, args, mods) abort
  let git = gina#core#get_or_fail()
  let args = s:build_args(git, a:args)

  let bufname = gina#core#buffer#bufname(git, s:SCHEME)
  call gina#core#buffer#open(bufname, {
        \ 'mods': a:mods,
        \ 'group': args.params.group,
        \ 'opener': args.params.opener,
        \ 'cmdarg': args.params.cmdarg,
        \ 'callback': {
        \   'fn': function('s:init'),
        \   'args': [args],
        \ }
        \})
endfunction


" Private --------------------------------------------------------------------
function! s:build_args(git, args) abort
  let args = a:args.clone()
  let args.params.group = args.pop('--group', '')
  let args.params.opener = args.pop('--opener', '')
  let args.params.detail = args.pop('--detail')

  return args.lock()
endfunction

function! s:init(args) abort
  call gina#core#meta#set('args', a:args)

  if exists('b:gina_initialized')
    return
  endif
  let b:gina_initialized = 1

  setlocal winfixwidth
  setlocal winfixheight
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal nomodifiable
  setlocal noautoread
  setlocal nolist nospell
  setlocal nowrap nonumber norelativenumber

  augroup gina_internal_command
    autocmd! * <buffer>
    autocmd BufReadCmd <buffer> call s:BufReadCmd()
    autocmd BufWipeout <buffer> call s:BufWipeout()
  augroup END
endfunction

function! s:BufReadCmd() abort
  call gina#core#emitter#remove_middleware(s:current.middleware)
  setlocal nobuflisted
  setlocal filetype=gina-_events
  let args = gina#core#meta#get_or_fail('args')
  let s:current.bufnr = bufnr('%')
  let s:current.middleware = copy(s:middleware)
  let s:current.middleware.detail = args.params.detail
  call gina#core#emitter#add_middleware(s:current.middleware)
endfunction

function! s:BufWipeout() abort
  call gina#core#emitter#remove_middleware(s:current.middleware)
endfunction

function! s:print_message(msg) abort
  let bufnr = s:current.bufnr
  if !bufnr || bufwinnr(bufnr) < 1
    call gina#core#emitter#remove_middleware(s:current.middleware)
    let s:current.bufnr = 0
    return
  endif
  " NOTE:
  " 'timer_start' is required for prevent E523 Not allowed here raised when
  " events are emitted from 'statusline' or 'tabline'
  call timer_start(0, { -> gina#core#writer#replace(bufnr, -1, -1, [a:msg]) })
endfunction

function! s:print_event(prefix, name, attrs) abort
  let width = gina#util#winwidth(bufwinnr(s:current.bufnr))
  let head = printf('%-5s: %s: %s',
        \ a:prefix,
        \ s:now(),
        \ a:name,
        \)
  let tail = printf('<%s>', bufname('%'))
  let args = join(map(copy(a:attrs), 'string(v:val)'), ', ')
  let args = substitute(args, '\r\?\n', '\\n', 'g')
  let args = substitute(args, '\e', '^[', 'g')
  let args = s:String.truncate_skipping(
        \ printf('(%s)', args),
        \ width - len(head) - len(tail) - 1,
        \ 3, '...'
        \)
  let head = head . args . ' '
  let message = head . s:String.pad_left(tail, width - len(head))
  call s:print_message(message)
endfunction

function! s:print_listeners(listeners) abort
  for [Listener, instance] in a:listeners
    call s:print_message(printf(
          \ '| %s [%s]',
          \ string(Listener),
          \ string(instance),
          \))
  endfor
endfunction


if has('python3')
  python3 import datetime
  function! s:now() abort
    return py3eval('datetime.datetime.now().strftime("%H:%M:%S.%f")')
  endfunction
elseif has('python')
  python import datetime
  function! s:now() abort
    return pyeval('datetime.datetime.now().strftime("%H:%M:%S.%f")')
  endfunction
else
  function! s:now() abort
    return strftime('%H:%M:%S.??????')
  endfunction
endif


" Middleware -----------------------------------------------------------------
let s:middleware = {'detail': 0}

function! s:middleware.on_emit_pre(name, listeners, attrs) abort
  call s:print_event('pre', a:name, a:attrs)
  if self.detail
    call s:print_listeners(a:listeners)
  endif
endfunction

function! s:middleware.on_emit_post(name, listeners, attrs) abort
  call s:print_event('post', a:name, a:attrs)
  if self.detail
    call s:print_listeners(a:listeners)
  endif
endfunction
