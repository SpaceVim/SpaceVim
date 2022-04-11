let s:save_cpo = &cpo
set cpo&vim
let s:name = '__JavaUnit__'

fu! javaunit#win#OpenWin(cmd)
    if bufwinnr('s:name') < 0
        if bufnr('s:name') != -1
            exe 'silent! split ' . '+b' . bufnr('s:name')
        else
            silent! split s:name
        endif
    else
        exec bufwinnr('s:name') . 'wincmd w'
    endif
    setl modifiable
    let result = systemlist(a:cmd)
    call s:windowsinit()
    call append(0, result)
    setl nomodifiable
endf
fu! s:windowsinit()
    " option
    setl fileformat=unix
    setl fileencoding=utf-8
    setl iskeyword=@,48-57,_
    setl noreadonly
    setl buftype=nofile
    setl bufhidden=wipe
    setl noswapfile
    setl nobuflisted
    setl nolist
    setl nonumber
    setl nowrap
    setl winfixwidth
    setl winfixheight
    setl textwidth=0
    setl nospell
    setl nofoldenable

    " map
    nnoremap <silent> <buffer> q :<c-u>bwipeout!<CR>

    " cmd


    let b:ctrlsf_initialized = 1
endf
let &cpo = s:save_cpo
unlet s:save_cpo
