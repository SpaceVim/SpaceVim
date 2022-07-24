" dispatch.vim headless strategy

if exists('g:autoloaded_dispatch_headless')
  finish
endif
let g:autoloaded_dispatch_headless = 1

function! dispatch#headless#handle(request) abort
  if !a:request.background || &shell !~# 'sh'
    return 0
  endif
  if a:request.action ==# 'make'
    let command = dispatch#prepare_make(a:request)
  elseif a:request.action ==# 'start'
    let command = dispatch#prepare_start(a:request)
  else
    return 0
  endif
  if &shellredir =~# '%s'
    let redir = printf(&shellredir, '/dev/null')
  else
    let redir = &shellredir . ' ' . '/dev/null'
  endif
  call system(&shell.' '.&shellcmdflag.' '.shellescape(command).redir.' &')
  return !v:shell_error
endfunction

function! dispatch#headless#activate(pid) abort
  return 0
endfunction
