function! util#redir_execute(command)
  redir => output
  silent execute a:command
  redir END
  return substitute(output, '^\n', '\1', '')
endfunction
