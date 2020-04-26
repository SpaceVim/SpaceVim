let s:JOB = SpaceVim#api#import('job')
let s:matched_lines = []

function! SpaceVim#plugins#foldsearch#word(word)
  let argv = ['rg', a:word]
  let s:matched_lines = []
  let jobid = s:JOB.start(argv, {
        \ 'on_stdout' : function('s:std_out'),
        \ 'on_exit' : function('s:exit'),
        \ })

endfunction


function! s:std_out(id, data, event) abort

endfunction

function! s:exit(id, data, event) abort
  
endfunction
