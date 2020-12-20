let cnt = 25

let start = reltime()

for i in range(1, cnt)
  call system('ls')
endfor

echomsg 'system()         = ' . reltimestr(reltime(start))

let start = reltime()

for i in range(1, cnt)
  call vimproc#system('ls')
endfor

echomsg 'vimproc#system() = ' . reltimestr(reltime(start))
