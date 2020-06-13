" For honza-snippets function.
function! vim_snippets#Filename(...) abort
  let filename = expand('%:t:r')
  if filename ==# ''
    return a:0 == 2 ? a:2 : ''
  elseif a:0 == 0 || a:1 ==# ''
    return filename
  else
    return substitute(a:1, '$1', filename, 'g')
  endif
endfunction
