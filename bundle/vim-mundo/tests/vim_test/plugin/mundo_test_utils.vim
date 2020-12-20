let s:undolevels_save = &undolevels

function! g:Goto(buffername)"{{{
    let l:winnr = bufwinnr(a:buffername)

    if l:winnr == -1
        return
    endif

    execute l:winnr . 'wincmd w'
endfunction"}}}

function! g:GotoLineContaining(text)"{{{
    let index = match(getline(1, '$'), '\V' . escape(a:text, '\'))

    if index == -1
        return
    endif

    call cursor(index + 1, 0)
endfunction"}}}

function! g:CurrentLineContains(text)"{{{
    return stridx(getline('.'), a:text) != -1
endfunction"}}}

function! g:Contains(text)"{{{
    return match(getline(1, '$'), '\V' . escape(a:text, '\')) != -1
endfunction"}}}

function! g:TypeLine(text)"{{{
    execute "normal i" . a:text . "\<C-g>u\n\e"
endfunction"}}}

function! g:TypeLineDone(text)"{{{
    execute "normal i" . a:text . "\n\e"

    " Break the undo chain
    let &undolevels = s:undolevels_save
endfunction"}}}

function! g:PrintTheFuckingBuffer()"{{{
    echo join(getline(1, '$'), "\n")
    echo "SOMETIMES I HATE YOU VIM"
endfunction"}}}

function! g:MoveUp()"{{{
    call cursor(line('.') - 1, 0)
endfunction"}}}

function! g:MoveDown()"{{{
    call cursor(line('.') + 1, 0)
endfunction"}}}
