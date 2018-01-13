let s:JOB = SpaceVim#api#import('job')
let s:job_id = 0
function! SpaceVim#dev#website#open()
  let path = expand('~/.SpaceVim/docs/')
  let cmd = ['bundle', 'exec', 'jekyll', 'serve']
  let s:job_id = s:JOB.start(cmd, {
        \ 'cwd' : path,
        \ 'on_stdout' : function('s:on_stdout'),
        \ })
endfunction


function! s:on_stdout(id, data, event) abort
  for data in a:data
    if data =~# 'Server address:'
      let address = split(data, 'address:')[1]
      exe 'OpenBrowser' address
    endif
  endfor
endfunction
