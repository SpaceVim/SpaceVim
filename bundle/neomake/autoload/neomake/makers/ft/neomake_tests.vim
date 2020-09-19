if !exists('g:neomake_test_messages')
    " Only use it during tests.
    finish
endif

function! neomake#makers#ft#neomake_tests#EnabledMakers() abort
    return get(b:, 'neomake_test_enabledmakers',
                \ get(g:, 'neomake_test_enabledmakers',
                \ ['maker_without_exe', 'nonexisting']))
endfunction

function! neomake#makers#ft#neomake_tests#maker_without_exe() abort
    return {}
endfunction

function! neomake#makers#ft#neomake_tests#maker_with_nonstring_exe() abort
    return {'exe': function('tr')}
endfunction

function! neomake#makers#ft#neomake_tests#echo_maker() abort
    return {
        \ 'exe': 'printf',
        \ 'args': 'neomake_tests_echo_maker',
        \ 'errorformat': '%m',
        \ 'append_file': 0,
        \ }
endfunction

function! neomake#makers#ft#neomake_tests#echo_args() abort
    return {
        \ 'exe': 'echo',
        \ 'errorformat': '%m',
        \ }
endfunction

function! neomake#makers#ft#neomake_tests#true() abort
    return {}
endfunction

function! neomake#makers#ft#neomake_tests#error_maker() abort
    return {
        \ 'exe': 'printf',
        \ 'args': ['%s:1:error_msg_1'],
        \ 'errorformat': '%E%f:%l:%m',
        \ 'append_file': 1,
        \ 'short_name': 'errmkr',
        \ }
endfunction

function! neomake#makers#ft#neomake_tests#process_output_error() abort
    let maker = {'exe': 'echo', 'args': 'output', 'append_file': 0}

    function! maker.process_output(...) abort
        return [{'valid': 1, 'text': 'error', 'lnum': 1, 'bufnr': bufnr('%')}]
    endfunction
    return maker
endfunction

function! neomake#makers#ft#neomake_tests#success_entry_maker() abort
    let maker = {}
    function! maker.get_list_entries(...) abort
        return []
    endfunction
    return maker
endfunction
" vim: ts=4 sw=4 et
