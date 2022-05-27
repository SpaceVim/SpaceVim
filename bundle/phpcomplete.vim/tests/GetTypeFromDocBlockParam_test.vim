fun! TestCase_returns_input_if_no_pipe_detected()
    let ret = phpcomplete#GetTypeFromDocBlockParam('FooClass')
    call VUAssertEquals('FooClass', ret)
endfun

fun! TestCase_returns_first_non_primitive_type()
    let ret = phpcomplete#GetTypeFromDocBlockParam('bool|FooClass')
    call VUAssertEquals('FooClass', ret)

    let ret = phpcomplete#GetTypeFromDocBlockParam('FooClass|bool')
    call VUAssertEquals('FooClass', ret)

    let ret = phpcomplete#GetTypeFromDocBlockParam('bool|string|BarClass|FooClass')
    call VUAssertEquals('BarClass', ret)

    let ret = phpcomplete#GetTypeFromDocBlockParam('string[]|BazClass')
    call VUAssertEquals('BazClass', ret)
endfun

fun! TestCase_returns_the_first_type_if_only_primitives_found()
    let ret = phpcomplete#GetTypeFromDocBlockParam('string|bool')
    call VUAssertEquals('string', ret)
endfun

" vim: foldmethod=marker:expandtab:ts=4:sts=4
