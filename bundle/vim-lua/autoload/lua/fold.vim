function! lua#fold#foldlevel(linenum) abort
    lua require('luavi').fold(require('luavi.vimutils').eval('a:linenum'))
endfunction


