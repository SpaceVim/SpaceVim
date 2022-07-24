" dispatch.vim Windows strategy

if exists('g:autoloaded_dispatch_windows')
  finish
endif
let g:autoloaded_dispatch_windows = 1

function! dispatch#windows#escape(str) abort
  if &shellxquote ==# '"'
    return '"' . substitute(a:str, '"', '""', 'g') . '"'
  else
    let esc = exists('+shellxescape') ? &shellxescape : '"&|<>()@^'
    return &shellxquote .
          \ substitute(a:str, '['.esc.']', '^&', 'g') .
          \ get({'(': ')', '"(': ')"'}, &shellxquote, &shellxquote)
  endif
endfunction

function! dispatch#windows#handle(request) abort
  if !has('win32') || empty(v:servername)
    return 0
  endif
  if a:request.action ==# 'make'
    return dispatch#windows#make(a:request)
  elseif a:request.action ==# 'start'
    return dispatch#windows#start(a:request)
  endif
endfunction

function! dispatch#windows#spawn(title, exec, background) abort
  let extra = a:background ? ' /min' : ''
  silent execute dispatch#bang('start /min cmd.exe /cstart ' .
        \ '"' . substitute(a:title, '"', '', 'g') . '"' . extra . ' ' .
        \ &shell . ' ' . &shellcmdflag . ' ' . dispatch#windows#escape(a:exec))
  return 1
endfunction

let s:pid = "wmic process where ^(Name='WMIC.exe' AND CommandLine LIKE '\\%\\%\\%TIME\\%\\%\\%'^) get ParentProcessId | more +1 > "

function! dispatch#windows#make(request) abort
  if &shellxquote ==# '"'
    let exec = dispatch#prepare_make(a:request)
  else
    let pidfile = a:request.file.'.pid'
    let exec =
          \ s:pid . pidfile .
          \ ' & ' . a:request.expanded .
          \ ' > ' . a:request.file . ' 2>&1' .
          \ ' & echo %ERRORLEVEL% > ' . a:request.file . '.complete' .
          \ ' & ' . dispatch#callback(a:request)
  endif

  return dispatch#windows#spawn(a:request.title, exec, 1)
endfunction

function! dispatch#windows#start(request) abort
  if &shellxquote ==# '"'
    let exec = dispatch#prepare_start(a:request)
  else
    let pidfile = a:request.file.'.pid'
    let pause = get({'always': ' & pause', 'never': ''},
          \ get(a:request, 'wait'), ' || pause')
    let exec =
          \ s:pid . pidfile .
          \ ' & ' . a:request.expanded .
          \ pause .
          \ ' & cd . > ' . a:request.file.'.complete' .
          \ ' & del ' . pidfile
  endif

  return dispatch#windows#spawn(a:request.title, exec, a:request.background)
endfunction

function! dispatch#windows#activate(pid) abort
  let tasklist_cmd = 'tasklist /fi "pid eq '.a:pid.'"'
  if &shellxquote ==# '"'
    let tasklist_cmd = substitute(tasklist_cmd, '"', "'", "g")
  endif
  if system(tasklist_cmd) !~# '==='
    return 0
  endif

  if !exists('s:activator')
    let s:activator = tempname().'.vbs'
    call writefile(['WScript.CreateObject("WScript.Shell").AppActivate(WScript.Arguments(0))'], s:activator)
  endif
  call system('cscript //nologo '.s:activator.' '.a:pid)
  return !v:shell_error
endfunction
