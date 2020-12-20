" Resource leak checker.

let max = 2048

for i in range(1, max)
  redraw
  echo i.'/'.max
  call vimproc#system('ls | head -20')
endfor

for i in range(1, max)
  redraw
  echo i.'/'.max

  let process = vimproc#pgroup_open('ls')
  while !process.stdout.eof
    call process.stdout.read(-1)
  endwhile

  let [_, status] = process.waitpid()
endfor
