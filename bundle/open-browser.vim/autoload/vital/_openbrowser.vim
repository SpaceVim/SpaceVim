let s:_plugin_name = expand('<sfile>:t:r')

function! vital#{s:_plugin_name}#new() abort
  return vital#{s:_plugin_name[1:]}#new()
endfunction

function! vital#{s:_plugin_name}#function(funcname) abort
  silent! return function(a:funcname)
endfunction
