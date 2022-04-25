let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

let s:commit_bufnr = -1

" Init 
let s:commit_context = []
let s:commit_jobid = -1

function! git#commit#run(...) abort
  if index(a:1, '-m') ==# -1
    if bufexists(s:commit_bufnr) && index(tabpagebuflist(), s:commit_bufnr) !=# -1
      let winnr = bufwinnr(s:commit_bufnr)
      exe winnr . 'wincmd w'
    else
      let s:commit_bufnr = s:openCommitBuffer()
    endif
  else
    let s:commit_bufnr = -1
  endif
  let s:commit_context = []
  if empty(a:1)
    let cmd = ['git', '--no-pager', '-c',
          \ 'core.editor=cat', '-c',
          \ 'color.status=always',
          \ '-C', 
          \ expand(getcwd(), ':p'),
          \ 'commit', '--edit']
  elseif index(a:1, '-m') != -1
    let cmd =  ['git', '--no-pager', '-c',
          \ 'core.editor=cat', '-c',
          \ 'color.status=always',
          \ '-C', 
          \ expand(getcwd(), ':p'),
          \ 'commit'] + a:1
  else
    let cmd =  ['git', '--no-pager', '-c',
          \ 'core.editor=cat', '-c',
          \ 'color.status=always',
          \ '-C', 
          \ expand(getcwd(), ':p'),
          \ 'commit',] + a:1
  endif
  let s:commit_jobid = s:JOB.start(cmd,
        \ {
        \ 'on_stderr' : function('s:on_stderr'),
        \ 'on_stdout' : function('s:on_stdout'),
        \ 'on_exit' : function('s:on_exit'),
        \ }
        \ )
endfunction

function! s:on_stdout(id, data, event) abort
  if a:id !=# s:commit_jobid
    " ignore previous git commit job
    return
  endif
  for data in a:data
    call git#logger#info('git-commit stdout:' . data)
  endfor
  let s:commit_context += a:data
endfunction
function! s:on_stderr(id, data, event) abort
  if a:id !=# s:commit_jobid
    " ignore previous git commit job
    return
  endif
  for data in a:data
    call git#logger#info('git-commit stderr:' . data)
  endfor
  " stderr should not be added to commit buffer
  " let s:commit_context += a:data
endfunction
function! s:on_exit(id, data, event) abort
  if a:id !=# s:commit_jobid
    " ignore previous git commit job
    return
  endif
  call git#logger#info('git-exit exit data:' . string(a:data))
  if s:commit_bufnr == -1
    if a:data ==# 0
      echo 'commit done!'
    else
      echo 'commit failed!'
    endif
  else
    call s:BUFFER.buf_set_lines(s:commit_bufnr, 0 , -1, 0, s:commit_context)
  endif
endfunction

function! s:openCommitBuffer() abort
  10split git://commit
  normal! "_dd
  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  setf git-commit
  nnoremap <buffer><silent> q :bd!<CR>
  let b:git_commit_quitpre = 0

  augroup git_commit_buffer
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer> call s:BufWriteCmd()
    autocmd QuitPre  <buffer> call s:QuitPre()
    autocmd WinLeave <buffer> call s:WinLeave()
    autocmd WinEnter <buffer> let b:git_commit_quitpre = 0
  augroup END
  return bufnr('%')
endfunction

" NOTE:
" :w      -- BufWriteCmd
" <C-w>p  -- WinLeave
" :wq     -- QuitPre -> BufWriteCmd -> WinLeave
" when run `:wq` the commit window will not be closed
" :q      -- QuitPre -> WinLeave
function! s:BufWriteCmd() abort
  let s:commit_context = getline(1, '$')
  setlocal nomodified
endfunction

function! s:QuitPre() abort
  let b:git_commit_quitpre = 1
endfunction

function! s:WinLeave() abort
  if b:git_commit_quitpre == 1
    let cmd = ['git', 'commit', '-F', '-']
    let id = s:JOB.start(cmd,
          \ {
          \ 'on_exit' : function('s:on_commit_exit'),
          \ }
          \ )
    " line start with # should be ignored
    call s:JOB.send(id, filter(s:commit_context, 'v:val !~# "^\s*#"'))
    call s:JOB.chanclose(id, 'stdin')
  endif
endfunction

function! s:on_commit_exit(id, data, event) abort
  call git#logger#info('git-commit exit data:' . string(a:data))
  if a:data ==# 0
    echo 'done!'
  else
    echo 'failed!'
  endif
endfunction
