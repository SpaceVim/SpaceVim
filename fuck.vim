let s:files = readfile('fuck.txt', '')
let s:cf = remove(s:files, 0)


let s:Job = SpaceVim#api#import('job')

function! s:on_exit(id, data, event) abort
  if a:data == 0
    echom 'downloaded:' . s:cf
    if !empty(s:files)
      let s:cf = remove(s:files, 0)
      call s:download(s:cf)
    endif
  else
    echom 'failed to download:' . s:cf
  endif
endfunction

function! s:download(cf) abort
  let cmd = ['curl', '-o', a:cf, 'https://user-images.githubusercontent.com/13142418/' . a:cf]
  let cwd = 'D:\wsdjeg\fuck-github-upload-img\docs'
  call s:Job.start(cmd, {
        \ 'on_exit' : function('s:on_exit'),
        \ 'cwd' : cwd
        \ })
endfunction

call s:download(s:cf)
