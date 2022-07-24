" dispatch.vim iTerm strategy

if exists('g:autoloaded_dispatch_iterm')
  finish
endif
let g:autoloaded_dispatch_iterm = 1

function! dispatch#iterm#handle(request) abort
  if $TERM_PROGRAM !=# 'iTerm.app' && !((has('gui_macvim') || has('gui_vimr')) && has('gui_running'))
    return 0
  endif
  if a:request.action ==# 'start'
    return dispatch#iterm#spawn(dispatch#prepare_start(a:request), a:request, !a:request.background)
  endif
endfunction

function! dispatch#iterm#is_modern_version() abort
  return s:osascript(
      \ 'on modernversion(version)',
      \   'set olddelimiters to AppleScript''s text item delimiters',
      \   'set AppleScript''s text item delimiters to "."',
      \   'set thearray to every text item of version',
      \   'set AppleScript''s text item delimiters to olddelimiters',
      \   'set major to item 1 of thearray',
      \   'set minor to item 2 of thearray',
      \   'set veryminor to item 3 of thearray',
      \   'if major < 2 then return false',
      \   'if major > 2 then return true',
      \   'if minor < 9 then return false',
      \   'if minor > 9 then return true',
      \   'if veryminor < 20140903 then return false',
      \   'return true',
      \ 'end modernversion',
      \ 'tell application "iTerm"',
      \   'if not my modernversion(version) then error',
      \ 'end tell')
endfunction

function! dispatch#iterm#spawn(command, request, activate) abort
  if dispatch#iterm#is_modern_version()
    return dispatch#iterm#spawn3(a:command, a:request, a:activate)
  else
    return dispatch#iterm#spawn2(a:command, a:request, a:activate)
  endif
endfunction

function! dispatch#iterm#spawn2(command, request, activate) abort
  let script = dispatch#isolate(a:request, [],
        \ dispatch#set_title(a:request), a:command)
  return s:osascript(
      \ 'if application "iTerm" is not running',
      \   'error',
      \ 'end if') && s:osascript(
      \ 'tell application "iTerm"',
      \   'tell the current terminal',
      \     'set oldsession to the current session',
      \     'tell (make new session)',
      \       'set name to ' . s:escape(a:request.title),
      \       'set title to ' . s:escape(a:request.expanded),
      \       'exec command ' . s:escape(script),
      \       a:request.background || !has('gui_running') ? 'select oldsession' : '',
      \     'end tell',
      \   'end tell',
      \   a:activate ? 'activate' : '',
      \ 'end tell')
endfunction

function! dispatch#iterm#spawn3(command, request, activate) abort
  let script = dispatch#isolate(a:request, [],
        \ dispatch#set_title(a:request), a:command)
  return s:osascript(
      \ 'if application "iTerm" is not running',
      \   'error',
      \ 'end if') && s:osascript(
      \ 'tell application "iTerm"',
      \   'tell the current window',
      \     'set oldtab to the current tab',
      \     'set newtab to (create tab with default profile command ' . s:escape(script) . ')',
      \     'tell current session of newtab',
      \       'set name to ' . s:escape(a:request.title),
      \       'set title to ' . s:escape(a:request.expanded),
      \     'end tell',
      \     a:request.background || !has('gui_running') ? 'select oldtab' : '',
      \   'end tell',
      \   a:activate ? 'activate' : '',
      \ 'end tell')
endfunction

function! dispatch#iterm#activate(pid) abort
  if dispatch#iterm#is_modern_version()
    return dispatch#iterm#activate3(a:pid)
  else
    return dispatch#iterm#activate2(a:pid)
  endif
endfunction

function! dispatch#iterm#activate2(pid) abort
  let tty = matchstr(system('ps -p '.a:pid), 'tty\S\+')
  if !empty(tty)
    return s:osascript(
        \ 'if application "iTerm" is not running',
        \   'error',
        \ 'end if') && s:osascript(
        \ 'tell application "iTerm"',
        \   'activate',
        \   'tell the current terminal',
        \      'select session id "/dev/'.tty.'"',
        \   'end tell',
        \ 'end tell')
  endif
endfunction

function! dispatch#iterm#activate3(pid) abort
  let tty = matchstr(system('ps -p '.a:pid), 'tty\S\+')
  if !empty(tty)
    return s:osascript(
        \ 'if application "iTerm" is not running',
        \   'error',
        \ 'end if') && s:osascript(
        \ 'tell application "iTerm"',
        \   'activate',
        \   'tell the current window',
        \     'repeat with atab in tabs',
        \       'repeat with asession in sessions',
        \         'if (tty) = ' . tty,
        \         'select atab',
        \       'end repeat',
        \     'end repeat',
        \   'end tell',
        \ 'end tell')
  endif
endfunction

function! s:osascript(...) abort
  call system('osascript'.join(map(copy(a:000), '" -e ".shellescape(v:val)'), ''))
  return !v:shell_error
endfunction

function! s:escape(string) abort
  return '"'.escape(a:string, '"\').'"'
endfunction
