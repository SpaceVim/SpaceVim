fun! SetUp()
    " disable builtin information
    let g:php_builtin_functions = {}
    " disable tag files
    exe ':set tags='
endf

fun! TestCase_return_VIMPHP_BUILTINFUNCTION_when_function_name_is_builtin()
    call SetUp()

    let g:php_builtin_functions = {
    \ 'array_map(': 'callable $callback, array $array1 [, array $...] | array',
    \ }

    let res = phpcomplete#GetFunctionLocation('array_map', '')
    call VUAssertEquals('VIMPHP_BUILTINFUNCTION', res)

    let res = phpcomplete#GetFunctionLocation('array_map', '\')
    call VUAssertEquals('VIMPHP_BUILTINFUNCTION', res)

    let res = phpcomplete#GetFunctionLocation('array_map', 'FooNS')
    call VUAssertEquals('VIMPHP_BUILTINFUNCTION', res)
endf

fun! TestCase_return_current_file_path_when_function_declaration_is_found_in_the_file()
    call SetUp()

    let path = expand('%:p:h').'/'.'fixtures/GetFunctionLocation/foo.function.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#GetFunctionLocation('foo', '')
    call VUAssertEquals(path, res)

    " function names are case in-sensitive
    let res = phpcomplete#GetFunctionLocation('foo2', '')
    call VUAssertEquals(path, res)

    silent! bw! %
endf

fun! TestCase_return_function_location_from_tags()
    call SetUp()

    let tags_path = expand('%:p:h').'/'.'fixtures/GetFunctionLocation/tags'
    let path = expand('%:p:h').'/'.'fixtures/GetFunctionLocation/empty.php'

    exe ':set tags='.tags_path
    below 1new
    exe ":silent! edit ".path
    exe ':3'

    let res = phpcomplete#GetFunctionLocation('foo', '')
    call VUAssertEquals('fixtures/GetFunctionLocation/foo.function.php', res)

    let res = phpcomplete#GetFunctionLocation('foo2', '')
    call VUAssertEquals('fixtures/GetFunctionLocation/foo.function.php', res)

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
