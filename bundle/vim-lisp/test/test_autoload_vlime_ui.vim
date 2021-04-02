function! NewDummyBuffer()
    noswapfile tabedit vlime_test_dummy_buffer
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted
endfunction

function! CleanupDummyBuffer()
    bunload!
endfunction


function! TestCurrentPackage()
    call NewDummyBuffer()
    try
        let ui = vlime#ui#New()
        call assert_equal(['COMMON-LISP-USER', 'CL-USER'], ui.GetCurrentPackage())

        call append(line('$'), '(in-package :dummy-package-1)')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal(['DUMMY-PACKAGE-1', 'DUMMY-PACKAGE-1'], ui.GetCurrentPackage())

        call ui.SetCurrentPackage(['DUMMY-PACKAGE-2', 'DUMMY-PACKAGE-2'])
        call assert_equal(['DUMMY-PACKAGE-2', 'DUMMY-PACKAGE-2'], ui.GetCurrentPackage())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurInPackage()
    call NewDummyBuffer()
    try
        call append(line('$'), '(in-package :dummy-package-1)')
        call assert_equal('DUMMY-PACKAGE-1', vlime#ui#CurInPackage())

        normal! ggVG_d
        call append(line('$'), '(in-package :dummy-package-1')
        call assert_equal('', vlime#ui#CurInPackage())

        normal! ggVG_d
        call append(line('$'), '(in-package :dummy-package-1 ()')
        call assert_equal('', vlime#ui#CurInPackage())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurrentThread()
    let ui = vlime#ui#New()
    call assert_equal(v:true, ui.GetCurrentThread())

    call ui.SetCurrentThread(1)
    call assert_equal(1, ui.GetCurrentThread())
endfunction

function! TestWithBuffer()
    function! s:DummyWithBufferAction()
        set filetype=vlime_test_dummy_ft
        let b:vlime_test_dummy_value = 2
    endfunction

    augroup VlimeTestWithBuffer
        autocmd!
        autocmd FileType vlime_test_dummy_ft let b:vlime_test_dummy_au_value = 4
    augroup end

    let b:vlime_test_dummy_value = 1
    let b:vlime_test_dummy_au_value = 3
    let new_buf = bufnr('vlime_test_with_buffer', v:true)
    call vlime#ui#WithBuffer(new_buf, function('s:DummyWithBufferAction'))
    call assert_equal(1, b:vlime_test_dummy_value)
    call assert_equal(2, getbufvar(new_buf, 'vlime_test_dummy_value'))
    call assert_equal(3, b:vlime_test_dummy_au_value)
    call assert_equal(4, getbufvar(new_buf, 'vlime_test_dummy_au_value'))
endfunction

function! TestOpenBuffer()
    let buf = vlime#ui#OpenBuffer(
                \ 'vlime_test_open_buffer', v:true, 'botright')
    call assert_equal('vlime_test_open_buffer', expand('%'))
    execute 'bunload!' buf

    let cur_buf_name = expand('%')
    let buf = vlime#ui#OpenBuffer(
                \ 'vlime_test_open_buffer_2', v:true, v:false)
    call assert_notequal('vlime_test_open_buffer_2', expand('%'))
endfunction

function! TestCloseBuffer()
    let new_buf = bufnr('vlime_test_close_buffer', v:true)
    let cur_win_id = win_getid()
    for i in range(5)
        execute 'tabedit #' . new_buf
    endfor
    call win_gotoid(cur_win_id)
    call vlime#ui#CloseBuffer(new_buf)
    call assert_equal(cur_win_id, win_getid())
    call assert_equal([], win_findbuf(new_buf))
endfunction

function! TestCurBufferContent()
    call NewDummyBuffer()
    try
        call append(0, ['line 1', 'line 2'])
        call assert_equal("line 1\nline 2\n", vlime#ui#CurBufferContent())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurChar()
    call NewDummyBuffer()
    try
        call append(line('$'), 'a')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('a', vlime#ui#CurChar())

        call append(line('$'), '字')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('字', vlime#ui#CurChar())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurAtom()
    call NewDummyBuffer()
    try
        call append(line('$'), 'dummy-atom-name')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('dummy-atom-name', vlime#ui#CurAtom())

        call append(line('$'), 'dummy/atom/name another-name')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('dummy/atom/name', vlime#ui#CurAtom())

        call append(line('$'), '*dummy-atom-name* another-name')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('*dummy-atom-name*', vlime#ui#CurAtom())

        call append(line('$'), '+dummy-atom-name+ another-name')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('+dummy-atom-name+', vlime#ui#CurAtom())

        call append(line('$'), 'yet-another-name dummy-package:dummy-atom-name another-name')
        call setpos('.', [0, line('$'), 18, 0])
        call assert_equal('dummy-package:dummy-atom-name', vlime#ui#CurAtom())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurExpr()
    call NewDummyBuffer()
    try
        call append(line('$'), '(cons 1 2)')
        call setpos('.', [0, line('$'), 1, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurExpr(v:true))

        call append(line('$'), '(cons (cons 1 2) 3)')
        call setpos('.', [0, line('$'), 1, 0])
        let cur_line = line('.')
        call assert_equal(['(cons (cons 1 2) 3)', [cur_line, 1], [cur_line, 19]],
                    \ vlime#ui#CurExpr(v:true))

        call append(line('$'), '(cons (cons 1 2) 3)')
        call setpos('.', [0, line('$'), 7, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 7], [cur_line, 16]],
                    \ vlime#ui#CurExpr(v:true))

        call append(line('$'), ['(cons', '1 2)'])
        call setpos('.', [0, line('$'), 1, 0])
        let cur_line = line('.')
        call assert_equal(["(cons\n1 2)", [cur_line - 1, 1], [cur_line, 4]],
                    \ vlime#ui#CurExpr(v:true))
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurTopExpr()
    call NewDummyBuffer()
    try
        call append(line('$'), '(cons 1 2)')
        call setpos('.', [0, line('$'), 1, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call setpos('.', [0, line('$'), 2, 0])
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call setpos('.', [0, line('$'), 10, 0])
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), ' (cons 1 2) ')
        call setpos('.', [0, line('$'), 12, 0])
        let cur_line = line('.')
        call assert_equal(['', [0, 0], [0, 0]],
                    \ vlime#ui#CurTopExpr(v:true))

        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal(['', [0, 0], [0, 0]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), '(list (cons 1 2) 3)')
        call setpos('.', [0, line('$'), 7, 0])
        let cur_line = line('.')
        call assert_equal(['(list (cons 1 2) 3)', [cur_line, 1], [cur_line, 19]],
                    \ vlime#ui#CurTopExpr(v:true))

        call setpos('.', [0, line('$'), 8, 0])
        call assert_equal(['(list (cons 1 2) 3)', [cur_line, 1], [cur_line, 19]],
                    \ vlime#ui#CurTopExpr(v:true))

        call setpos('.', [0, line('$'), 16, 0])
        call assert_equal(['(list (cons 1 2) 3)', [cur_line, 1], [cur_line, 19]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), '(cons (list (cons 1 2) 3) 4)')
        call setpos('.', [0, line('$'), 18, 0])
        let cur_line = line('.')
        call assert_equal(['(cons (list (cons 1 2) 3) 4)', [cur_line, 1], [cur_line, 28]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), ['#| #(, |# (cons 1 2) #| ) |#'])
        call setpos('.', [0, line('$'), 12, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 11], [cur_line, 20]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), [';; #(,', '(cons 1 2)', ';; )'])
        call setpos('.', [0, line('$') - 1, 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), ['"#(,"', '(cons 1 2)', '")"'])
        call setpos('.', [0, line('$') - 1, 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), ['"\\"', '(cons 1 2)'])
        call setpos('.', [0, line('$'), 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        call append(line('$'), ['#\"', '(cons 1 2)'])
        call setpos('.', [0, line('$'), 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))


        " Enable syntax highlighting, and see if comments and strings are
        " correctly recognized.
        syntax on
        set filetype=lisp

        "call append(line('$'), ['#| #(, |# (cons 1 2) #| ) |#'])
        call setpos('.', [0, line('$') - 10, 12, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 11], [cur_line, 20]],
                    \ vlime#ui#CurTopExpr(v:true))

        "call append(line('$'), [';; #(,', '(cons 1 2)', ';; )'])
        call setpos('.', [0, line('$') - 8, 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        "call append(line('$'), ['"#(,"', '(cons 1 2)', '")"'])
        call setpos('.', [0, line('$') - 5, 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        "call append(line('$'), ['"\\"', '(cons 1 2)'])
        call setpos('.', [0, line('$') - 2, 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))

        "call append(line('$'), ['#\"', '(cons 1 2)'])
        call setpos('.', [0, line('$'), 2, 0])
        let cur_line = line('.')
        call assert_equal(['(cons 1 2)', [cur_line, 1], [cur_line, 10]],
                    \ vlime#ui#CurTopExpr(v:true))
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurOperator()
    call NewDummyBuffer()
    try
        call append(line('$'), ' (cons 1 2) ')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 2, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 3, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 11, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 12, 0])
        call assert_equal('', vlime#ui#CurOperator())

        call append(line('$'), '(cons (list 1 2) 3)')
        call setpos('.', [0, line('$'), 6, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call append(line('$'), '(cons (list 1 2) 3)')
        call setpos('.', [0, line('$'), 7, 0])
        call assert_equal('list', vlime#ui#CurOperator())

        call append(line('$'), '(cons (list 1 2) 3)')
        call setpos('.', [0, line('$'), 16, 0])
        call assert_equal('list', vlime#ui#CurOperator())

        call append(line('$'), '(cons (list 1 2) 3)')
        call setpos('.', [0, line('$'), 17, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call append(line('$'), '(cons (list 1 2')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 6, 0])
        call assert_equal('cons', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 7, 0])
        call assert_equal('list', vlime#ui#CurOperator())

        call setpos('.', [0, line('$'), 15, 0])
        call assert_equal('list', vlime#ui#CurOperator())

        call append(line('$'), '((aa bb) cc')
        call setpos('.', [0, line('$'), 11, 0])
        call assert_equal('', vlime#ui#CurOperator())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestSurroundingOperator()
    call NewDummyBuffer()
    try
        call append(line('$'), '(cons (list 1 2) 3)')
        call setpos('.', [0, line('$'), 6, 0])
        call assert_equal('cons', vlime#ui#SurroundingOperator())

        call setpos('.', [0, line('$'), 7, 0])
        call assert_equal('cons', vlime#ui#SurroundingOperator())

        call setpos('.', [0, line('$'), 8, 0])
        call assert_equal('list', vlime#ui#SurroundingOperator())

        call setpos('.', [0, line('$'), 16, 0])
        call assert_equal('list', vlime#ui#SurroundingOperator())

        call setpos('.', [0, line('$'), 17, 0])
        call assert_equal('cons', vlime#ui#SurroundingOperator())

        call append(line('$'), '((a b) (c d))')
        call setpos('.', [0, line('$'), 2, 0])
        call assert_equal('', vlime#ui#SurroundingOperator())

        call setpos('.', [0, line('$'), 8, 0])
        call assert_equal('', vlime#ui#SurroundingOperator())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestCurArgPosForIndent()
    call NewDummyBuffer()
    try
        call append(line('$'), '(aa bb cc dd)')
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal(-1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 2, 0])
        call assert_equal(0, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 4, 0])
        call assert_equal(1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 5, 0])
        call assert_equal(1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 7, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 8, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 13, 0])
        call assert_equal(3, vlime#ui#CurArgPos())

        call append(line('$'), '(aa bb cc dd )')
        call setpos('.', [0, line('$'), 14, 0])
        call assert_equal(4, vlime#ui#CurArgPos())

        call append(line('$'), ['(aa bb', 'cc dd)'])
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call append(line('$'), ['(aa bb', '  cc dd)'])
        call setpos('.', [0, line('$'), 1, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call append(line('$'), '(aa bb (cc dd) ee)')
        call setpos('.', [0, line('$'), 8, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 9, 0])
        call assert_equal(0, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 11, 0])
        call assert_equal(1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 12, 0])
        call assert_equal(1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 15, 0])
        call assert_equal(3, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 16, 0])
        call assert_equal(3, vlime#ui#CurArgPos())

        call append(line('$'), '((aa bb) (cc dd) ee)')
        call setpos('.', [0, line('$'), 2, 0])
        call assert_equal(0, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 10, 0])
        call assert_equal(1, vlime#ui#CurArgPos())

        call setpos('.', [0, line('$'), 18, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call append(line('$'), "(aa bb '(cc dd) ee)")
        call setpos('.', [0, line('$'), 9, 0])
        call assert_equal(2, vlime#ui#CurArgPos())

        call append(line('$'), ["(aa", "  bb)"])
        call setpos('.', [0, line('$') - 1, 3, 0])
        call assert_equal(0, vlime#ui#CurArgPos())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestAppendString()
    call NewDummyBuffer()
    try
        call assert_equal(0, vlime#ui#AppendString('line1'))
        call assert_equal(1, vlime#ui#AppendString(" line1 line1\n"))
        call assert_equal(1, vlime#ui#AppendString("line2\nline3"))
        call assert_equal(3, vlime#ui#AppendString("\nline5\nline6\nline7"))
        call assert_equal("line1 line1 line1\nline2\nline3\nline5\nline6\nline7",
                    \ vlime#ui#CurBufferContent())

        call assert_equal(1, vlime#ui#AppendString(" and\nline2.1\n", 2))
        call assert_equal("line1 line1 line1\nline2 and\nline2.1\nline3\nline5\nline6\nline7",
                    \ vlime#ui#CurBufferContent())
        call assert_equal(0, vlime#ui#AppendString("\nline2.2 and ", 3))
        call assert_equal("line1 line1 line1\nline2 and\nline2.1\nline2.2 and line3\nline5\nline6\nline7",
                    \ vlime#ui#CurBufferContent())
        call assert_equal(1, vlime#ui#AppendString("line0\n", 0))
        call assert_equal("line0\nline1 line1 line1\nline2 and\nline2.1\nline2.2 and line3\nline5\nline6\nline7",
                    \ vlime#ui#CurBufferContent())

        call assert_equal(2, vlime#ui#ReplaceContent("new line5\nnew line6\n", 6, 7))
        call assert_equal("line0\nline1 line1 line1\nline2 and\nline2.1\nline2.2 and line3\nnew line5\nnew line6\nline7",
                    \ vlime#ui#CurBufferContent())

        call assert_equal(1, vlime#ui#ReplaceContent("replaced\ncontent"))
        call assert_equal("replaced\ncontent", vlime#ui#CurBufferContent())

        call assert_equal(1, vlime#ui#ReplaceContent("some other\ntext"))
        call assert_equal("some other\ntext", vlime#ui#CurBufferContent())
    finally
        call CleanupDummyBuffer()
    endtry
endfunction

function! TestMatchCoord()
    let coord = {
                \ 'begin': [1, 2],
                \ 'end': [1, 2],
                \ 'type': 'DUMMY',
                \ 'id': 1,
                \ }
    call assert_true(vlime#ui#MatchCoord(coord, 1, 2))
    call assert_false(vlime#ui#MatchCoord(coord, 1, 1))
    call assert_false(vlime#ui#MatchCoord(coord, 1, 3))
    call assert_false(vlime#ui#MatchCoord(coord, 2, 2))

    let coord = {
                \ 'begin': [1, 2],
                \ 'end': [1, 12],
                \ 'type': 'DUMMY',
                \ 'id': 1,
                \ }
    call assert_true(vlime#ui#MatchCoord(coord, 1, 2))
    call assert_true(vlime#ui#MatchCoord(coord, 1, 7))
    call assert_true(vlime#ui#MatchCoord(coord, 1, 12))
    call assert_false(vlime#ui#MatchCoord(coord, 1, 1))
    call assert_false(vlime#ui#MatchCoord(coord, 1, 13))
    call assert_false(vlime#ui#MatchCoord(coord, 2, 7))

    let coord = {
                \ 'begin': [1, 10],
                \ 'end': [2, 5],
                \ 'type': 'DUMMY',
                \ 'id': 1,
                \ }
    call assert_true(vlime#ui#MatchCoord(coord, 1, 15))
    call assert_true(vlime#ui#MatchCoord(coord, 2, 3))
    call assert_false(vlime#ui#MatchCoord(coord, 1, 5))
    call assert_false(vlime#ui#MatchCoord(coord, 2, 7))
endfunction

function! TestEnsureKeyMapped()
    call NewDummyBuffer()
    try
        silent! unmap <space>
        silent! unmap <buffer> <space>
        call vlime#ui#EnsureKeyMapped('n', '<space>', ':smile<cr>', v:false, 'test_ensurekeymapped')
        call assert_equal(':smile<CR>', maparg('<space>', 'n'))

        let g:vlime_skipped_mappings = {}
        call vlime#ui#EnsureKeyMapped('n', '<space>', ':smile<cr>', v:false, 'test_ensurekeymapped')
        call assert_equal({
                    \ 'test_ensurekeymapped': {
                        \ 'n <space>': [':smile<cr>', 'Command already mapped.']
                    \ }}, g:vlime_skipped_mappings)

        let g:vlime_skipped_mappings = {}
        call vlime#ui#EnsureKeyMapped('n', '<space>', ':help<cr>', v:false, 'test_ensurekeymapped')
        call assert_equal({
                    \ 'test_ensurekeymapped': {
                        \ 'n <space>': [':help<cr>', 'Key already mapped.']
                    \ }}, g:vlime_skipped_mappings)

        let g:vlime_skipped_mappings = {}
        call vlime#ui#EnsureKeyMapped('n', '<space>', ':smile<cr>', v:true, 'test_ensurekeymapped')
        call assert_equal(':smile<CR>', maparg('<space>', 'n'))
        call assert_equal({}, g:vlime_skipped_mappings)

        let g:vlime_skipped_mappings = {}
        call vlime#ui#EnsureKeyMapped('n', '<space>', ':help<cr>', v:true, 'test_ensurekeymapped')
        call assert_equal(':help<CR>', maparg('<space>', 'n'))
        call assert_equal({}, g:vlime_skipped_mappings)
    finally
        unlet g:vlime_skipped_mappings
        call CleanupDummyBuffer()
    endtry
endfunction

let v:errors = []
call TestCurrentPackage()
call TestCurInPackage()
call TestCurrentThread()
call TestWithBuffer()
call TestOpenBuffer()
call TestCloseBuffer()
call TestCurBufferContent()
call TestCurChar()
call TestCurAtom()
call TestCurExpr()
call TestCurTopExpr()
call TestCurOperator()
call TestSurroundingOperator()
call TestCurArgPosForIndent()
call TestAppendString()
call TestMatchCoord()
call TestEnsureKeyMapped()
