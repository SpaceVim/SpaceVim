let s:NUM = SpaceVim#api#import('data#number')

function! org#util#random(range) abort

 return s:NUM.random(1, a:range)   

endfunction
