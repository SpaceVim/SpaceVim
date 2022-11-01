source plugin/javacomplete.vim
source autoload/javacomplete.vim
source autoload/java_parser.vim

function! g:SID(file) abort
  redir => l:scriptnames
  silent scriptnames
  redir END
  for line in split(l:scriptnames, '\n')
    let [l:sid, l:path] = matchlist(line, '^\s*\(\d\+\):\s*\(.*\)$')[1:2]
    if l:path =~# '\<autoload[/\\]javacomplete[/\\]'.a:file.'\.vim$'
      return '<SNR>' . l:sid . '_'
    endif
  endfor
endfunction
