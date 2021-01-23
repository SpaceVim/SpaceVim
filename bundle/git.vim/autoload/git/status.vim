let s:JOB = SpaceVim#api#import('job')
let s:BUFFER = SpaceVim#api#import('vim#buffer')

let s:status_bufnr = -1

function! git#status#run(...) abort
  if bufexists(s:status_bufnr) && index(tabpagebuflist(), s:status_bufnr) !=# -1
    let winnr = bufwinnr(s:status_bufnr)
    exe winnr . 'wincmd w'
  else
    let s:status_bufnr = s:openStatusBuffer()
  endif
  let cmd = ['git', 'status', '.']
  let s:lines = []
  call git#logger#info('git-status cmd:' . string(cmd))
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
    call git#logger#info('git-status stdout:' . data)
  endfor
  let s:lines += a:data
endfunction
function! s:on_stderr(id, data, event) abort
  for data in a:data
    call git#logger#info('git-status stderr:' . data)
  endfor
  let s:lines += a:data
endfunction
function! s:on_exit(id, data, event) abort
  call git#logger#info('git-status exit data:' . string(a:data))
  call s:BUFFER.buf_set_lines(s:status_bufnr, 0 , -1, 0, s:lines)
endfunction


function! s:openStatusBuffer() abort
  10split git://status
  normal! "_dd
  setl nobuflisted
  setl nomodifiable
  setl nonumber norelativenumber
  setl buftype=nofile
  setl bufhidden=wipe
  setf git-status
  nnoremap <buffer><silent> q :call <SID>close_status_window()<CR>
  " https://github.com/vim/vim/commit/a8eee21e75324d199acb1663cb5009e03014a13a
  return bufnr('%')
endfunction

function! s:close_status_window() abort
  if winnr('$') > 1
    close
  else
    bd!
  endif
endfunction
