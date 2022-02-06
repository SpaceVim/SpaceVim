fun! SetUp()
    " normalize g:phpcomplete_min_num_of_chars_for_namespace_completion option
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 2
    " disable built-in classes
    let g:php_builtin_classnames = {}
    let g:php_builtin_classes = {}
    " disable built-in interfaces
    let g:php_builtin_interfaces = {}
    let g:php_builtin_interfacenames = {}
    " disable built-in functions
    let g:php_builtin_functions = {}
    " disable tags
    exe ':set tags='
endf

fun! TestCase_returns_empty_strings_when_symbol_not_found()
    call SetUp()

    let res = phpcomplete#LocateSymbol('no_such_thing', '', '', {})
    call VUAssertEquals(['', '', ''], res)
endf

fun! TestCase_returns_symbol_locations()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(18, 2)
    let res = phpcomplete#LocateSymbol('get_foo', '', '', {})
    call VUAssertEquals([path, 15, 10], res)

    call cursor(18, 13)
    let res = phpcomplete#LocateSymbol('baz', 'get_foo()->', '', {})
    call VUAssertEquals([path, 4, 18], res)

    call cursor(20, 3)
    let res = phpcomplete#LocateSymbol('Foo', '', '', {})
    call VUAssertEquals([path, 2, 7], res)

    call cursor(20, 7)
    let res = phpcomplete#LocateSymbol('baz', 'Foo::', '', {})
    call VUAssertEquals([path, 4, 18], res)

    silent! bw! %
endf

fun! TestCase_returns_symbol_locations_with_namespaces()
    call SetUp()

    exe ':set tags='.expand('%:p:h').'/'.'fixtures/GetCurrentSymbolWithContext/namespaced_tags'

    let foo2_path = expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'
    let path = expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/namespaced_foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(24, 25)
    let res = phpcomplete#LocateSymbol('returnFoo2', '$f2->returnBaz2()->', 'NS1', {})
    call VUAssertEquals([foo2_path, 22, 18], res)

    call cursor(28, 10)
    let res = phpcomplete#LocateSymbol('returnBaz2', '$f2->', 'NS1', {})
    call VUAssertEquals([foo2_path, 11, 18], res)

    silent! bw! %
endf

fun! TestCase_returns_location_for_inherited_methods()
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/GetCurrentSymbolWithContext/inherited_tags'

    let base_path = expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/base_foo.php'
    let path = expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/child_foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(7, 10)
    let res = phpcomplete#LocateSymbol('inherited', '$f->', '', {})
    call VUAssertEquals([base_path, 5, 18], res)

    silent! bw! %
endf

fun! TestCase_returns_locations_for_reference_returning_functions()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/foo_references.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(16, 5)
    let res = phpcomplete#LocateSymbol('return_foo_ref', '', '', {})
    call VUAssertEquals([path, 13, 11], res)

    call cursor(16, 32)
    let res = phpcomplete#LocateSymbol('return_foo_ref_method', 'return_foo_ref()->', '', {})
    call VUAssertEquals([path, 4, 19], res)

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
