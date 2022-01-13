let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

function! git#rebase#run(...) abort
  let s:bufnr = s:openRebaseCommitBuffer()
  let s:lines = []
  if !empty(a:1)
    let cmd = ['git', '--no-pager', '-c',
          \ 'core.editor=cat', '-c',
          \ 'color.status=always',
          \ '-C', 
          \ expand(getcwd(), ':p'),
          \ 'rebase'] + a:1
  else
    finish
  endif
  call git#logger#info('git-rebase cmd:' . string(cmd))
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
    call git#logger#info('git-rebase stdout:' . data)
  endfor
  let s:lines += a:data
endfunction
function! s:on_stderr(id, data, event) abort
  for data in a:data
    call git#logger#info('git-rebase stderr:' . data)
  endfor
  " stderr should not be added to commit buffer
  " let s:lines += a:data
endfunction
function! s:on_exit(id, data, event) abort
  call git#logger#info('git-rebase exit data:' . string(a:data))
  call s:BUFFER.buf_set_lines(s:bufnr, 0 , -1, 0, s:lines)
endfunction

function! s:openRebaseCommitBuffer() abort
  10split git://rebase
  normal! "_dd
  setlocal nobuflisted
  setlocal buftype=acwrite
  setlocal bufhidden=wipe
  setlocal noswapfile
  setlocal modifiable
  setf git-rebase
  nnoremap <buffer><silent> q :bd!<CR>
  let b:git_rebase_quitpre = 0

  augroup git_commit_buffer
    autocmd! * <buffer>
    autocmd BufWriteCmd <buffer> call s:BufWriteCmd()
    autocmd QuitPre  <buffer> call s:QuitPre()
    autocmd WinLeave <buffer> call s:WinLeave()
    autocmd WinEnter <buffer> let b:git_rebase_quitpre = 0
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
  let commit_file = '.git\COMMIT_EDITMSG'
  call writefile(getline(1, '$'), commit_file)
  setlocal nomodified
endfunction

function! s:QuitPre() abort
  let b:git_rebase_quitpre = 1
endfunction

function! s:WinLeave() abort
  if b:git_rebase_quitpre == 1
    let cmd = ['git', 'rebase', '--continue']
    call git#logger#info('git-rebase cmd:' . string(cmd))
    let id = s:JOB.start(cmd,
          \ {
          \ 'on_exit' : function('s:on_rebase_continue'),
          \ }
          \ )
    " line start with # should be ignored
  endif
endfunction

function! s:on_rebase_continue(id, data, event) abort
  call git#logger#info('git-rebase exit data:' . string(a:data))
  if a:data ==# 0
    echo 'done!'
  else
    echo 'failed!'
  endif
endfunction

