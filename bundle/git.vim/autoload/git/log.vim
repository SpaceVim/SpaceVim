let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:NOTI = SpaceVim#api#import('notify')

let g:git_log_pretty = 'tformat:%Cred%h%Creset - %s %Cgreen(%an %ad)%Creset'
let s:bufnr = -1

function! git#log#run(...) abort
  if len(a:1) == 1 && a:1[0] ==# '%'
    let cmd = ['git', 'log', '--graph', '--date=relative', '--pretty=' . g:git_log_pretty, expand('%')] 
  else
    let cmd = ['git', 'log', '--graph', '--date=relative', '--pretty=' . g:git_log_pretty] + a:1
  endif
  call git#logger#info('git-log cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_exit' : function('s:on_exit'),
          \ }
          \ )
endfunction

function! s:on_stdout(id, data, event) abort
  if !bufexists(s:bufnr)
    let s:bufnr = s:openLogBuffer()
  endif
  call s:BUFFER.buf_set_lines(s:bufnr, getline('$') ==# '' ? 0 : -1 , -1, 0, a:data)
endfunction
function! s:on_stderr(id, data, event) abort
  for data in a:data
    let s:NOTI.notify_max_width = strwidth(data) + 5
    let s:NOTI.timeout = 3000
    call s:NOTI.notify(data, 'WarningMsg')
  endfor
endfunction
function! s:on_exit(id, data, event) abort
  call git#logger#info('git-log exit data:' . string(a:data))
endfunction

function! s:openLogBuffer() abort
  let bp = bufnr('%')
  edit git://log
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-log
  nnoremap <buffer><silent> <Cr> :call <SID>show_commit()<CR>
  nnoremap <buffer><silent> q :call <SID>close_log_win()<CR>
  return bufnr('%')
endfunction

function! git#log#complete(ArgLead, CmdLine, CursorPos) abort

  return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

let s:show_commit_buffer = -1
function! s:show_commit() abort
  let commit = matchstr(getline('.'), '^[* |\\\/_]\+\zs[a-z0-9A-Z]\+')
  if empty(commit)
    return
  endif
  if !bufexists(s:show_commit_buffer)
    let s:show_commit_buffer = s:openShowCommitBuffer()
  endif
  let cmd = ['git', 'show', commit]
  let s:show_lines = []
  call s:JOB.start(cmd,
        \ {
          \ 'on_stderr' : function('s:on_show_stderr'),
          \ 'on_stdout' : function('s:on_show_stdout'),
          \ 'on_exit' : function('s:on_show_exit'),
          \ }
          \ )
endfunction

function! s:on_show_stdout(id, data, event) abort
  for data in a:data
    call git#logger#info('git-show stdout:' . data)
  endfor
  let s:show_lines += filter(a:data, '!empty(v:val)')
endfunction
function! s:on_show_stderr(id, data, event) abort
  for data in a:data
    call git#logger#info('git-show stderr:' . data)
  endfor
  let s:show_lines += filter(a:data, '!empty(v:val)')
endfunction
function! s:on_show_exit(id, data, event) abort
  call git#logger#info('git-show exit data:' . string(a:data))
  call s:BUFFER.buf_set_lines(s:show_commit_buffer, 0 , -1, 0, s:show_lines)
endfunction
function! s:openShowCommitBuffer() abort
  rightbelow vsplit git://show_commit
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-diff
  setl syntax=diff
  nnoremap <buffer><silent> q :q<CR>
  return bufnr('%')
endfunction

function! s:close_log_win() abort
  call s:closeShowCommitWindow()
  try
    bp
  catch /^Vim\%((\a\+)\)\=:E85/
    bd
  endtry
endfunction

function! s:closeShowCommitWindow() abort
  if bufexists(s:show_commit_buffer)
    exe 'bd ' . s:show_commit_buffer
  endif
endfunction
