fun! SetUp()
    " normalize g:phpcomplete_min_num_of_chars_for_namespace_completion option
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 2
    " disable built-in classes
    let g:php_builtin_classnames = {}
    " disable built-in interfaces
    let g:php_builtin_interfaces = {}
    " disable built-in interfaces
    let g:php_builtin_interfacenames = {}
    " disable tags
    exe ':set tags='
endf

fun! TestCase_returns_empty_strings_when_outside_php_block()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(26, 1)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['', '', '', ''], res)

    silent! bw! %
endf

fun! TestCase_returns_current_symbol_under_cursor()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(18, 5)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['get_foo', '', '', {}], res)

    call cursor(18, 13)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['baz', 'get_foo()->', '', {}], res)

    call cursor(20, 1)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['Foo', '', '', {}], res)

    call cursor(20, 8)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['baz', 'Foo::', '', {}], res)

    call cursor(23, 29)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['returnFoo2', '$f2->returnBaz2()->', '', {}], res)

    silent! bw! %
endf

fun! TestCase_returns_current_symbol_with_the_current_namespace_and_imports()
    call SetUp()

    exe ':set tags='.expand('%:p:h').'/'.'fixtures/GetCurrentSymbolWithContext/namespaced_tags'

    let path = expand('%:p:h')."/".'fixtures/GetCurrentSymbolWithContext/namespaced_foo.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(21, 5)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['get_foo', '', 'NS1', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    call cursor(21, 13)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['baz', 'get_foo()->', 'NS1', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    call cursor(23, 18)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['Foo2', 'new \NS2\', 'NS2', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    call cursor(27, 18)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['Foo2', 'new', 'NS2', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    call cursor(3, 10)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['Foo2', 'use NS2\', 'NS2', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    call cursor(3, 20)
    let res = phpcomplete#GetCurrentSymbolWithContext()
    call VUAssertEquals(['Foo2', 'use NS2\Foo2 as', 'NS2', {'RenamedFoo2': {'cmd': '/^class Foo2 {$/', 'static': 0, 'name': 'Foo2', 'namespace': 'NS2', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/GetCurrentSymbolWithContext/namespaced_foo2.php'}}], res)

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
