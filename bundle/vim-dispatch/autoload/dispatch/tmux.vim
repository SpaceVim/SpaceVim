" dispatch.vim tmux strategy

if exists('g:autoloaded_dispatch_tmux')
  finish
endif
let g:autoloaded_dispatch_tmux = 1

let s:waiting = {}
let s:make_pane = tempname()

function! dispatch#tmux#handle(request) abort
  let session = get(g:, 'tmux_session', '')
  if empty($TMUX) && empty(''.session) || !executable('tmux')
    return 0
  endif
  if !empty(system('tmux has-session -t '.shellescape(session))[0:-2])
    return ''
  endif

  if a:request.action ==# 'make'
    if !get(a:request, 'background', 0) && !dispatch#has_callback() &&
          \ !empty(''.session) && session !=# system('tmux display-message -p "#S"')[0:-2]
      return 0
    endif
    return dispatch#tmux#make(a:request)
  elseif a:request.action ==# 'start'
    let command = 'tmux new-window -P -t '.shellescape(session.':')
    let command .= ' -n '.shellescape(a:request.title)
    if a:request.background
      let command .= ' -d'
    endif
    let command .= ' ' . shellescape('exec ' . dispatch#isolate(
          \ a:request, ['TMUX', 'TMUX_PANE'],
          \ dispatch#set_title(a:request),
          \ dispatch#prepare_start(a:request)))
    call system(command)
    return 1
  endif
endfunction

function! dispatch#tmux#make(request) abort
  let pipepane = get(g:, 'dispatch_tmux_pipe_pane', 0)
        \ && a:request.format !~# '%\\[er]'
  let session = get(g:, 'tmux_session', '')
  let script = dispatch#isolate(a:request, ['TMUX', 'TMUX_PANE'],
        \ call('dispatch#prepare_make', [a:request] +
        \ (pipepane ? [a:request.expanded . '; echo ' . dispatch#status_var()
        \  . ' > ' . a:request.file . '.complete'] : [])))

  let title = shellescape(a:request.title)
  let height = get(g:, 'dispatch_tmux_height', get(g:, 'dispatch_quickfix_height', 10))
  if get(a:request, 'background', 0) || (height <= 0 && dispatch#has_callback())
    let cmd = 'new-window -d -n '.title
  elseif has('gui_running') || empty($TMUX) || (!empty(''.session) && session !=# system('tmux display-message -p "#S"')[0:-2])
    let cmd = 'new-window -n '.title
  else
    let cmd = 'split-window -l '.(height < 0 ? -height : height).' -d'
  endif

  let cmd .= ' ' . dispatch#shellescape('-P', '-t', session.':', 'exec ' . script)

  let filter = 'sed'
  let uname = system('uname')[0:-2]
  if uname ==# 'Darwin'
    let filter = '/usr/bin/sed -l'
  elseif uname ==# 'Linux'
    let filter .= ' -u'
  endif
  let filter .= " -e \"s/\r\r*$//\" -e \"s/.*\r//\""
  let filter .= " -e \"s/\e\\[K//g\" "
  let filter .= " -e \"s/.*\e\\[2K\e\\[[01]G//g\""
  let filter .= " -e \"s/.*\e\\[?25h\e\\[0G//g\""
  let filter .= " -e \"s/\e\\[[0-9;]*m//g\""
  let filter .= " -e \"s/\017//g\""
  let filter .= " > " . a:request.file . ""
  call system('tmux ' . cmd . '|tee ' . s:make_pane .
        \ (pipepane ? '|xargs -I {} tmux pipe-pane -t {} '.shellescape(filter) : ''))

  let pane = s:pane_id(get(readfile(s:make_pane, '', 1), 0, ''))
  if !empty(pane)
    let s:waiting[pane] = a:request
    return 1
  endif
endfunction

function! s:pane_id(pane) abort
  if a:pane =~# '\.\d\+$'
    let [window, index] = split(a:pane, '\.\%(\d\+$\)\@=')
    let out = system('tmux list-panes -F "#P #{pane_id}" -t '.shellescape(window))
    let id = matchstr("\n".out, '\n'.index.' \+\zs%\d\+')
  else
    let id = system('tmux list-panes -F "#{pane_id}" -t '.shellescape(a:pane))[0:-2]
  endif
  return id
endfunction

function! dispatch#tmux#poll() abort
  if empty(s:waiting)
    return
  endif
  let panes = split(system('tmux list-panes -a -F "#{pane_id}"'), "\n")
  for [pane, request] in items(s:waiting)
    if index(panes, pane) < 0
      call remove(s:waiting, pane)
      call dispatch#complete(request)
    endif
  endfor
endfunction

function! dispatch#tmux#activate(pid) abort
  let out = system('ps ewww -p '.a:pid)
  let pane = matchstr(out, 'TMUX_PANE=\zs%\d\+')
  if empty(pane)
    return 0
  endif
  let session = get(g:, 'tmux_session', '')
  if !empty(session)
    let session = ' -t '.shellescape(session)
  endif
  let panes = split(system('tmux list-panes -s -F "#{pane_id}"'.session), "\n")
  if index(panes, pane) >= 0
    call system('tmux select-window -t '.pane.'; tmux select-pane -t '.pane)
    return !v:shell_error
  endif
endfunction

augroup dispatch_tmux
  autocmd!
  autocmd VimResized * nested if !dispatch#has_callback() | call dispatch#tmux#poll() | endif
augroup END
