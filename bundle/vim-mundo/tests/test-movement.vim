UTSuite [Mundo] Testing Movement

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
        exec 'bwipeout! ' . bufnr('__Mundo__')
    endif
    if bufnr('__Mundo_Preview__') != -1
        exec 'bwipeout! ' . bufnr('__Mundo_Preview__')
    endif
    if bufnr('test') != -1
        exec 'bwipeout! ' . bufnr('test')
    endif
    if bufnr('test2') != -1
        exec 'bwipeout! ' . bufnr('test2')
    endif
endfunction"}}}

function! s:TestMovementBasic()"{{{
    " Make three linear changes
    call g:TypeLineDone("ONE")
    call g:TypeLineDone("TWO")
    call g:TypeLineDone("THREE")

    " Open Mundo
    MundoToggle

    " Make sure we're on the newest/current state
    Assert g:CurrentLineContains("[3]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[2]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[1]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[0]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[1]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[2]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[3]")

    " Test arrow mappings

    " Move down
    exec "normal \<down>"
    Assert g:CurrentLineContains("[2]")

    " Move down
    exec "normal \<down>"
    Assert g:CurrentLineContains("[1]")

    " Move down
    exec "normal \<down>"
    Assert g:CurrentLineContains("[0]")

    " Move up
    exec "normal \<up>"
    Assert g:CurrentLineContains("[1]")

    " Move up
    exec "normal \<up>"
    Assert g:CurrentLineContains("[2]")

    " Move up
    exec "normal \<up>"
    Assert g:CurrentLineContains("[3]")
endfunction"}}}

function! s:TestMovementLinear()"{{{
    " Make four changes:
    "
    " o    [4]
    " |
    " | o  [3]
    " | |
    " o |  [2]
    " |/
    " o    [1]
    " |
    " o    [0] (original)

    call g:TypeLineDone("ONE")
    call g:TypeLineDone("TWO")
    silent! undo
    call g:TypeLineDone("THREE")
    silent! undo 2
    call g:TypeLineDone("FOUR")

    " Open Mundo
    MundoToggle

    " Make sure we're on the newest/current state
    Assert g:CurrentLineContains("[4]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[3]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[2]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[1]")

    " Move down
    normal j
    Assert g:CurrentLineContains("[0]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[1]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[2]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[3]")

    " Move up
    normal k
    Assert g:CurrentLineContains("[4]")
endfunction"}}}
