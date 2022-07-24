" dispatch.vim GNU Screen strategy

if exists('g:autoloaded_dispatch_screen')
  finish
endif
let g:autoloaded_dispatch_screen = 1

function! dispatch#screen#handle(request) abort
  if empty($STY) || !executable('screen')
    return 0
  endif
  if a:request.action ==# 'make'
    if !get(a:request, 'background', 0) && !dispatch#has_callback()
      return 0
    endif
    return dispatch#screen#spawn(dispatch#prepare_make(a:request), a:request)
  elseif a:request.action ==# 'start'
    return dispatch#screen#spawn(dispatch#prepare_start(a:request), a:request)
  endif
endfunction

function! dispatch#screen#spawn(command, request) abort
  let command = 'screen -ln -fn -t '.dispatch#shellescape(a:request.title)
        \ . ' ' . &shell . ' ' . &shellcmdflag . ' '
        \ . shellescape('exec ' . dispatch#isolate(a:request,
        \ ['STY', 'WINDOW'], dispatch#set_title(a:request), a:command))
  silent execute dispatch#bang(command)
  if (a:request.background || a:request.action !=# 'start') && !has('gui_running') && !has('nvim')
    silent !screen -X other
  endif
  return 1
endfunction

function! dispatch#screen#activate(pid) abort
  let out = system('ps ewww -p '.a:pid)
  if empty($STY) || stridx(out, 'STY='.$STY) < 0
    return 0
  endif
  let window = matchstr(out, 'WINDOW=\zs\d\+')
  if !empty(window)
    silent execute '!screen -X select '.window
    return !v:shell_error
  endif
endfunction
