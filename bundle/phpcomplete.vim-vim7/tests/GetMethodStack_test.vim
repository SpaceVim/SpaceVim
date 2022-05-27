fun! TestCase_returns_the_line_splited_on_arrows_and_double_colons()
    let res = phpcomplete#GetMethodStack('$this->foo()->bar()')
    call VUAssertEquals(['$this', 'foo()', 'bar()'], res)

    let res = phpcomplete#GetMethodStack('Foo::bar()->baz')
    call VUAssertEquals(['Foo', 'bar()', 'baz'], res)
endf

fun! TestCase_ignores_arrows_and_double_colons_inside_paretns()
    let res = phpcomplete#GetMethodStack('Foo::bar($foobar->foo())->baz')
    call VUAssertEquals(['Foo', 'bar($foobar->foo())', 'baz'], res)
endf

fun! TestCase_ignores_arrows_and_double_colons_and_parents_inside_strings()
    let res = phpcomplete#GetMethodStack('Foo::bar($foobar->foo(" ) -> :: '' \" \\"))->baz')
    call VUAssertEquals(['Foo', 'bar($foobar->foo(" ) -> :: '' \" \\"))', 'baz'], res)
endf

fun! TestCase_have_no_empty_element_on_the_end_if_the_context_ended_with_an_arrow_or_double_colon()
    let res = phpcomplete#GetMethodStack('Foo::bar()->')
    call VUAssertEquals(['Foo', 'bar()'], res)

    let res = phpcomplete#GetMethodStack('Foo::bar::')
    call VUAssertEquals(['Foo', 'bar'], res)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
