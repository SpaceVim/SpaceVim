fun! SetUp()
    " disable builtin information
    let g:php_builtin_functions = {}
    " disable tag files
    exe ':set tags='
    let g:fixture_file_content = readfile(expand('%:p:h').'/'.'fixtures/GetFunctionReturnTypeHint/functions.php')[2:]
endf

fun! TestCase_return_current_file_path_when_function_declaration_is_found_in_the_file()
    call SetUp()

    let ret = phpcomplete#GetFunctionReturnTypeHint(g:fixture_file_content, 'function\s*\<returnFoo\>')
    call VUAssertEquals('Foo', ret)

    let ret = phpcomplete#GetFunctionReturnTypeHint(g:fixture_file_content, 'function\s*\<returnBar\>')
    call VUAssertEquals('Bar', ret)

    let ret = phpcomplete#GetFunctionReturnTypeHint(g:fixture_file_content, 'function\s*\<returnBar2\>')
    call VUAssertEquals('Bar2', ret)
endf
