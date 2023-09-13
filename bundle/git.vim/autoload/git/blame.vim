let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')
let s:STRING = SpaceVim#api#import('data#string')

let s:blame_buffer_nr = -1
let s:blame_show_buffer_nr = -1
" @todo rewrite Git blame in lua
function! git#blame#run(...)
  if len(a:1) == 0
    let cmd = ['git', 'blame', '--line-porcelain', expand('%')] 
  else
    let cmd = ['git', 'blame', '--line-porcelain'] + a:1
  endif
  let s:lines = []
  call git#logger#debug('git-blame cmd:' . string(cmd))
  call s:JOB.start(cmd,
        \ {
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:on_stdout(id, data, event) abort
  for data in a:data
    call git#logger#debug('git-blame stdout:' . data)
  endfor
  let s:lines += a:data
endfunction
function! s:on_stderr(id, data, event) abort
  for data in a:data
    call git#logger#debug('git-blame stderr:' . data)
  endfor
endfunction
function! s:on_exit(id, data, event) abort
  call git#logger#debug('git-blame exit data:' . string(a:data))
  let rst = s:parser(s:lines)
  if !empty(rst)
    if !bufexists(s:blame_buffer_nr)
      let s:blame_buffer_nr = s:openBlameWindow()
    endif
    call setbufvar(s:blame_buffer_nr, 'git_blame_info', rst)
    call s:BUFFER.buf_set_lines(s:blame_buffer_nr, 0 , -1, 0, map(deepcopy(rst), 's:STRING.fill(v:val.summary, 40) . repeat(" ", 4) . strftime("%Y %b %d %X", v:val.time)'))
    let fname = rst[0].filename
    if !bufexists(s:blame_show_buffer_nr)
      let s:blame_show_buffer_nr = s:openBlameShowWindow(fname)
    endif
    call s:BUFFER.buf_set_lines(s:blame_show_buffer_nr, 0 , -1, 0, map(deepcopy(rst), 'v:val.line'))
  endif
endfunction


function! s:openBlameWindow() abort
  tabedit git://blame
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl scrollbind
  setf git-blame
  setlocal bufhidden=wipe
  nnoremap <buffer><silent> <Cr> :call <SID>open_previous()<CR>
  nnoremap <buffer><silent> <BS> :call <SID>back()<CR>
  nnoremap <buffer><silent> q :call <SID>close_blame_win()<CR>
  return bufnr('%')
endfunction

function! s:openBlameShowWindow(fname) abort
  exe 'rightbelow vsplit git://blame:show/' . a:fname
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl scrollbind
  setl buftype=nofile
  setlocal bufhidden=wipe
  nnoremap <buffer><silent> q :bd!<CR>
  return bufnr('%')
endfunction

function! s:close_blame_win() abort
  let s:blame_history = []
  call s:closeBlameShowWindow()
  q
endfunction

function! s:closeBlameShowWindow() abort
  if bufexists(s:blame_show_buffer_nr)
    exe 'bd ' . s:blame_show_buffer_nr
  endif
endfunction

" revision
" 1cca0b8676d664d2ea2f9b0756d41967fc8481fb 1 1 5
" author Shidong Wang
" author-mail <wsdjeg@outlook.com>
" author-time 1578202864
" author-tz +0800
" committer Shidong Wang
" committer-mail <wsdjeg@outlook.com>
" committer-time 1578202864
" committer-tz +0800
" summary Add git blame support
" filename autoload/git/blame.vim
" let s:JOB = SpaceVim#api#import('job')
function! s:parser(lines) abort
  let rst = []
  let obj = {}
  for line in a:lines
    if line =~# '^[a-zA-Z0-9]\{40}'
      call extend(obj, {'revision' : line[:39]})
    elseif line =~# '^summary'
      call extend(obj, {'summary' : line[8:]})
    elseif line =~# '^filename'
      call extend(obj, {'filename' : line[9:]})
    elseif line =~# '^previous'
      call extend(obj, {'previous' : line[9:48]})
    elseif line =~# '^committer-time'
      call extend(obj, {'time' : str2nr(line[15:])})
    elseif line =~# '^\t'
      call extend(obj, {'line' : line[1:]})
      if !empty(obj) && has_key(obj, 'summary') && has_key(obj, 'line')
        call add(rst, obj)
      endif
      let obj = {}
    endif
  endfor
  return rst
endfunction

let s:blame_history = []

function! s:back() abort
  if empty(s:blame_history)
    echo 'No navigational history is found'
    return
  endif
  let [rev, fname] = remove(s:blame_history, -1)
  exe 'Git blame' rev fname
endfunction

function! s:open_previous() abort
  let rst = get(b:, 'git_blame_info', [])
  if empty(rst)
    return
  endif
  let blame_info = rst[line('.') - 1]
  if has_key(blame_info, 'previous')
    call add(s:blame_history, [blame_info.revision, blame_info.filename])
    exe 'Git blame' blame_info.previous blame_info.filename
  else
    echo 'No related parent commit exists'
  endif
endfunction

function! git#blame#complete(ArgLead, CmdLine, CursorPos)

  return "%\n" . join(getcompletion(a:ArgLead, 'file'), "\n")

endfunction

