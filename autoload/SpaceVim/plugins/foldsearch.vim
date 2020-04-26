let s:JOB = SpaceVim#api#import('job')
let s:matched_lines = []

function! SpaceVim#plugins#foldsearch#word(word)
  let argv = ['rg', '--line-number', a:word]
  let s:matched_lines = []
  let jobid = s:JOB.start(argv, {
        \ 'on_stdout' : function('s:std_out'),
        \ 'on_exit' : function('s:exit'),
        \ })

  call s:JOB.send(jobid, call('getline', [1, '$']))
  call s:JOB.chanclose(jobid, 'stdin')
endfunction


function! s:std_out(id, data, event) abort
  for line in filter(a:data, '!empty(v:val)')
    call add(s:matched_lines, str2nr(matchstr(line, '^\d\+')))
  endfor

endfunction

function! s:exit(id, data, event) abort
  echom string(s:matched_lines)
endfunction
