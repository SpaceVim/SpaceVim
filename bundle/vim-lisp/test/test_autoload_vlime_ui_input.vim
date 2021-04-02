function! TestSaveHistory()
    call assert_false(exists('g:vlime_input_history'))

    call vlime#ui#input#SaveHistory('some text')
    call assert_equal(['some text'], g:vlime_input_history)

    call vlime#ui#input#SaveHistory('other text')
    call assert_equal(['some text', 'other text'], g:vlime_input_history)

    call vlime#ui#input#SaveHistory('some other text')
    call assert_equal(['some text', 'other text', 'some other text'], g:vlime_input_history)

    unlet g:vlime_input_history
endfunction

function! TestGetHistory()
    call assert_false(exists('g:vlime_input_history'))
    call vlime#ui#input#SaveHistory('some text')
    call vlime#ui#input#SaveHistory('other text')
    call vlime#ui#input#SaveHistory('some other text')

    call assert_equal([2, 'some other text'], vlime#ui#input#GetHistory())
    call assert_equal([1, 'other text'], vlime#ui#input#GetHistory('backward', 2))
    call assert_equal([0, 'some text'], vlime#ui#input#GetHistory('backward', 1))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward', 0))

    call assert_equal([1, 'other text'], vlime#ui#input#GetHistory('forward', 0))
    call assert_equal([2, 'some other text'], vlime#ui#input#GetHistory('forward', 1))
    call assert_equal([3, ''], vlime#ui#input#GetHistory('forward', 2))
    call assert_equal([3, ''], vlime#ui#input#GetHistory('forward', 3))
    call assert_equal([3, ''], vlime#ui#input#GetHistory('forward'))

    let g:vlime_input_history = []
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward'))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward', 0))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward', 1))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward'))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward', 0))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward', 1))

    unlet g:vlime_input_history
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward'))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward', 0))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('backward', 1))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward'))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward', 0))
    call assert_equal([0, ''], vlime#ui#input#GetHistory('forward', 1))
endfunction

function! TestNextHistoryItem()
    call assert_false(exists('g:vlime_input_history'))
    call vlime#ui#input#SaveHistory('some text')
    call vlime#ui#input#SaveHistory('other text')
    call vlime#ui#input#SaveHistory('some other text')

    noswapfile tabedit vlime_test_dummy_buffer
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal nobuflisted

    try
        call vlime#ui#AppendString('original text')
        call assert_equal('original text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('forward')
        call assert_equal('original text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('backward')
        call assert_equal('some other text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('backward')
        call assert_equal('other text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('backward')
        call assert_equal('some text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('backward')
        call assert_equal('some text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('forward')
        call assert_equal('other text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('forward')
        call assert_equal('some other text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('forward')
        call assert_equal('original text', vlime#ui#CurBufferContent())

        call vlime#ui#input#NextHistoryItem('forward')
        call assert_equal('original text', vlime#ui#CurBufferContent())
    finally
        bdelete!
        unlet g:vlime_input_history
    endtry
endfunction

let v:errors = []
call TestSaveHistory()
call TestGetHistory()
call TestNextHistoryItem()
