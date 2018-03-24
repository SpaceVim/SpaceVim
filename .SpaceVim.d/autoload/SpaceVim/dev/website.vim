let s:JOB = SpaceVim#api#import('job')
let s:job_id = 0
let s:server_address = ''
function! SpaceVim#dev#website#open() abort
  let path = expand('~/.SpaceVim/docs/')
  let cmd = ['bundle', 'exec', 'jekyll', 'serve']
  if s:job_id == 0 && s:server_address ==# ''
    let s:job_id = s:JOB.start(cmd, {
          \ 'cwd' : path,
          \ 'on_stdout' : function('s:on_stdout'),
          \ 'on_stderr' : function('s:on_stderr'),
          \ 'on_exit' : function('s:on_exit'),
          \ })
  else
    exe 'OpenBrowser' s:server_address
  endif
endfunction

function! SpaceVim#dev#website#terminal() abort
  if s:job_id != 0
    call s:JOB.stop(s:job_id)
  endif
endfunction

" @vimlint(EVL103, 1, a:event)
" @vimlint(EVL103, 1, a:id)
" @vimlint(EVL103, 1, a:data)
function! s:on_stdout(id, data, event) abort
  for data in a:data
    if data =~# 'Server address:'
      let s:server_address = split(data, 'address:')[1]
      exe 'OpenBrowser' s:server_address
    endif
  endfor
endfunction

function! s:on_stderr(id, data, event) abort
  for data in a:data
    echohl WarningMsg
    echom 'SpaceVim website:' . data
    echohl None
  endfor
endfunction

" @vimlint(EVL103, 0, a:id)
" @vimlint(EVL103, 0, a:data)
" @vimlint(EVL103, 0, a:event)

function! s:on_exit(...) abort
  let s:job_id = 0
  let s:server_address = ''
endfunction


" vim:set et sw=2 cc=80:
