function! SpaceVim#api#import(name) abort
  let p = {}
  try
    let p = SpaceVim#api#{a:name}#get()
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction

" vim:set fdm=marker sw=2 nowrap:
