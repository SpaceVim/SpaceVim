" Resource leak checker version2(for process group).

let pwd = fnamemodify(expand('<sfile>'), ':p:h')

let process = vimproc#pgroup_open('python ' . pwd . '/fork.py')

call process.waitpid()
" call process.kill()

let process = vimproc#pgroup_open('ls && ls')
while !process.stdout.eof
  call process.stdout.read(-1)
endwhile

call process.waitpid()

if executable('ps')
  echomsg string(split(system('ps -eo pid,pgid,sid,args | grep defunct'), '\n'))
  echomsg 'Current pid = ' . getpid()
endif
