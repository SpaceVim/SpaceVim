fun! SetUp()
    let g:phpcomplete_complete_for_unknown_classes = 1
    " disable built-in functions
    let g:php_builtin_object_functions = {}
    " disable tags
    exe ':set tags='
endf

fun! TestCase_returns_class_properties_from_current_file()
    call SetUp()

    " load fixture with variables in it
    let path =  expand('%:p:h')."/".'fixtures/CompleteUnknownClass/foo_properties.class.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteUnknownClass("prop", "$a->")

    call VUAssertEquals([
                \ {'word': 'property1', 'info': ' ', 'kind': 'v'},
                \ {'word': 'property2', 'info': ' ', 'kind': 'v'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_returns_functions_from_current_file()
    call SetUp()

    " load fixture with methods and functions in it
    let path =  expand('%:p:h')."/".'fixtures/CompleteUnknownClass/foo_methods.class.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteUnknownClass("met", "$a->")

    " TODO: At this moment, the code finds private and protected methods, it should not do that
    " TODO: At this moment, the code doesn't take filter for staticness of results
    call VUAssertEquals([
                \ {'word': 'method1(', 'info': 'method1($foo)', 'menu': '$foo)', 'kind': 'f'},
                \ {'word': 'method2(', 'info': 'method2($foo)', 'menu': '$foo)', 'kind': 'f'},
                \ {'word': 'method3(', 'info': 'method3($foo)', 'menu': '$foo)', 'kind': 'f'},
                \ {'word': 'method4(', 'info': 'method4($foo)', 'menu': '$foo)', 'kind': 'f'},
                \ {'word': 'method5(', 'info': 'method5($foo)', 'menu': '$foo)', 'kind': 'f'},
                \ {'word': 'method6(', 'info': 'method6($foo)', 'menu': '$foo)', 'kind': 'f'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_completes_function_signature_from_tags_if_field_available()
    call SetUp()

    " disable tags
    exe 'set tags='.expand('%:p:h')."/".'fixtures/CompleteUnknownClass/patched_tags'

    " load an empty fixture so no local functions / variables show up
    let path =  expand('%:p:h')."/".'fixtures/CompleteUnknownClass/empty.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteUnknownClass("method_with_", "$a->")

    " TODO: At this moment, the code finds functions that are not in a class
    " (so they are no methods)
    " TODO: At this moment, the code doesn't take filter for staticness
    call VUAssertEquals([
                \ {'word': 'method_with_arguments(', 'info': "method_with_arguments($bar = 42, $foo = '') - fixtures/CompleteUnknownClass/irrelevant.class.php", 'menu': "$bar = 42, $foo = '') - fixtures/CompleteUnknownClass/irrelevant.class.php", 'kind': 'f'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_returns_functions_from_tags()
    call SetUp()

    " disable tags
    exe 'set tags='.expand('%:p:h')."/".'fixtures/CompleteUnknownClass/tags'

    " load an empty fixture so no local functions / variables show up
    let path =  expand('%:p:h')."/".'fixtures/CompleteUnknownClass/empty.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteUnknownClass("fun", "$a->")

    " TODO: At this moment, the code finds functions that are not in a class
    " (so they are no methods)
    " TODO: At this moment, the code doesn't take filter for staticness
    call VUAssertEquals([
                \ {'word': 'function1(', 'info': 'function1($baz = ''foo'') - fixtures/CompleteUnknownClass/irrelevant.php', 'menu': '$baz = ''foo'') - fixtures/CompleteUnknownClass/irrelevant.php', 'kind': 'f'},
                \ {'word': 'function2(', 'info': 'function2($baz = ''foo'') - fixtures/CompleteUnknownClass/irrelevant.php', 'menu': '$baz = ''foo'') - fixtures/CompleteUnknownClass/irrelevant.php', 'kind': 'f'},
                \ {'word': 'function3(', 'info': 'function3() - fixtures/CompleteUnknownClass/irrelevant.php', 'menu': ') - fixtures/CompleteUnknownClass/irrelevant.php', 'kind': 'f'},
                \ {'word': 'function4(', 'info': 'function4() - fixtures/CompleteUnknownClass/irrelevant.php', 'menu': ') - fixtures/CompleteUnknownClass/irrelevant.php', 'kind': 'f'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_returns_built_in_object_functions()
    call SetUp()

    " load an empty fixture so no local functions / variables show up
    let path =  expand('%:p:h')."/".'fixtures/CompleteUnknownClass/empty.php'
    below 1new
    exe ":silent! edit ".path

    " disable built-in functions
    let g:php_builtin_object_functions = {
                \ 'DateTime::add(': 'DateInterval $interval | DateTime',
                \ 'DateTime::setDate(': 'int $year, int $month, int $day | DateTime',
                \ }

    let res = phpcomplete#CompleteUnknownClass("set", "$d->")

    " TODO: At this moment, the code doesn't take filter for staticness
    call VUAssertEquals([{
                \ 'word': 'setDate(',
                \ 'info': 'DateTime::setDate(int $year, int $month, int $day | DateTime',
                \ 'menu': 'int $year, int $month, int $day | DateTime',
                \ 'kind': 'f'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_returns_empty_list_when_unknown_class_completion_disabled()
    call SetUp()

    let g:phpcomplete_complete_for_unknown_classes = 0
    let res = phpcomplete#CompleteUnknownClass("setDat", "$d->")
    call VUAssertEquals([], res)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
