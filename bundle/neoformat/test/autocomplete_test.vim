let s:tests = {}
" Utilities
function! s:Run(function)
    let o = &filetype
    " let output = call(a:function, [''])
    " call function(a:function)
    let output = call(a:function, [])
    let &filetype = o
    " expecting output to either be a 1 or 0
    let s:tests[a:function[2:]] = output
    return output
endfunction

function! s:Cleanup()
    let error = 0
    for test in keys(s:tests)
        if !s:tests[test]
            let error = 1
        endif
        echom test . ' : ' . s:tests[test]
    endfor

    if error
        " make vim exit with a non-zero value
        cquit!
    else
        qall!
    endif
endfunction

" Test Definitions
function! s:valid_option()
    let &filetype = 'python'

    let g:neoformat_python_enabled = ['autopep8', 'yapf']
    let out = neoformat#CompleteFormatters('auto','', 0)

    return ['autopep8'] == out
endfunction

function! s:invalid_option()
    let &filetype = 'javascript'

    let g:neoformat_python_enabled = ['autopep8']
    let out = neoformat#CompleteFormatters('autopep8', '', 0)

    return [] == out
endfunction

function! s:formtprg_option()
    let &filetype = 'javascript'
    let &formatprg = 'testing'
    let out = neoformat#CompleteFormatters('test', '', 0)

    return [] == out
endfunction

" Run Tests
call s:Run('s:valid_option')
call s:Run('s:invalid_option')
call s:Run('s:formtprg_option')


" Check the outputs
call s:Cleanup()
