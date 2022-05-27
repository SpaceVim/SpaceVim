fun! s:DetectTL()
    if getline(1) =~# '^#!.*/bin/env\s\+tl\>'
        setfiletype teal
    endif
endfun

autocmd BufRead,BufNewFile *.tl setlocal filetype=teal
autocmd BufNewFile,BufRead * call s:DetectTL()
