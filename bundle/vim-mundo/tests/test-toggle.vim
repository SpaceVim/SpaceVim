UTSuite [Mundo] Testing Toggling

function! s:Setup()"{{{
    exec 'edit test'
    call g:Goto('test')
endfunction"}}}
function! s:Teardown()"{{{
    if bufwinnr(bufnr('__Mundo__')) != -1
        exec bufwinnr(bufnr('__Mundo__')) . 'wincmd w'
        quit
    endif
    if bufwinnr(bufnr('__Mundo_Preview__')) != -1
        exec bufwinnr(bufnr('__Mundo_Preview__')) . 'wincmd w'
        quit
    endif
    if bufnr('__Mundo__') != -1
        exec 'bwipeout ' . bufnr('__Mundo__')
    endif
    if bufnr('__Mundo_Preview__') != -1
        exec 'bwipeout ' . bufnr('__Mundo_Preview__')
    endif
    if bufnr('test') != -1
        exec 'bwipeout ' . bufnr('test')
    endif
    if bufnr('test2') != -1
        exec 'bwipeout ' . bufnr('test2')
    endif
endfunction"}}}

function! s:TestToggleBasic()"{{{
    " Make sure we're starting from scratch.
    Assert bufnr('__Mundo__') == -1
    Assert bufnr('__Mundo_Preview__') == -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1

    " Open Mundo
    MundoToggle

    " Buffers and windows should exist.
    Assert bufnr('__Mundo__') != -1
    Assert bufnr('__Mundo_Preview__') != -1
    Assert bufwinnr(bufnr('__Mundo__')) != -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) != -1

    " We should be in the Mundo pane.
    Assert expand('%') == '__Mundo__'

    " Close Mundo
    MundoToggle

    " Windows should have been closed, but buffers should remain.
    Assert bufnr('__Mundo__') != -1
    Assert bufnr('__Mundo_Preview__') != -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1
endfunction"}}}

function! s:TestToggleWhenMoved()"{{{
    " Make sure we're starting from scratch.
    Assert bufnr('__Mundo__') == -1
    Assert bufnr('__Mundo_Preview__') == -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1

    " Open Mundo
    MundoToggle

    call g:Goto('test')
    Assert expand('%') == 'test'

    " Close Mundo
    MundoToggle

    " Windows should have been closed, but buffers should remain.
    Assert bufnr('__Mundo__') != -1
    Assert bufnr('__Mundo_Preview__') != -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1

    " Open Mundo
    MundoToggle

    call g:Goto('__Mundo_Preview__')
    Assert expand('%') == '__Mundo_Preview__'

    " Close Mundo
    MundoToggle

    " Windows should have been closed, but buffers should remain.
    Assert bufnr('__Mundo__') != -1
    Assert bufnr('__Mundo_Preview__') != -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1
endfunction"}}}

function! s:TestToggleReturnToTarget()"{{{
    " Make sure we're starting from scratch.
    Assert bufnr('__Mundo__') == -1
    Assert bufnr('__Mundo_Preview__') == -1
    Assert bufwinnr(bufnr('__Mundo__')) == -1
    Assert bufwinnr(bufnr('__Mundo_Preview__')) == -1

    exec 'new test2'
    call g:Goto('test')

    " Toggle Mundo
    MundoToggle
    MundoToggle

    " We should be returned to test
    Assert expand('%') == 'test'

    " Move to test2
    call g:Goto('test2')

    " Toggle Mundo
    MundoToggle
    MundoToggle

    " We should be returned to test2
    Assert expand('%') == 'test2'
endfunction"}}}
