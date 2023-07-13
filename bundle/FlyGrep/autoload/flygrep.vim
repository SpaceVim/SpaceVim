function! flygrep#open(argv) abort
	call SpaceVim#plugins#flygrep#open(a:argv)
endfunction

function! flygrep#statusline() abort
    let st = ' FlyGrep %{getcwd()} '
    return st . "%{getline(1) ==# '' ? '' : (line('.') . '/' . line('$'))}"
endfunction
