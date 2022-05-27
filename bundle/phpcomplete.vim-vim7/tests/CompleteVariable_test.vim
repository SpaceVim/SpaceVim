fun! SetUp()
    " disable tag files
    exe ':set tags='

    " disable builtin variables
    let g:php_builtin_vars = {}
    let g:phpcomplete_search_tags_for_variables = 0
endf

fun! TestCase_complete_variables_from_current_file()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/CompleteVariable/local_variables.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteVariable('$find')

    " -> added for the variable detected as an object
    call VUAssertEquals([
                \ {'word': '$find_me', 'kind': 'v'},
                \ {'word': '$find_me2', 'kind': 'v'},
                \ {'word': '$find_me3', 'kind': 'v'},
                \ {'word': '$find_me4', 'kind': 'v'}
                \],
                \ res)
    silent! bw! %
endf

fun! TestCase_complete_variables_built_in_global_variable()
    call SetUp()

    " disable local variables from current file
    let path =  expand('%:p:h')."/".'fixtures/CompleteVariable/empty.php'
    below 1new
    exe ":silent! edit ".path

    " fill with test data '$this' is in the list to test that filtering
    " actually happens to the '$_' base
    let g:php_builtin_vars = {
                \ '$_GET':'',
                \ '$_POST':'',
                \ '$this':'',
                \ }

    let res = phpcomplete#CompleteVariable('$_')
    call VUAssertEquals([
                \ {'word': '$_GET', 'kind': 'v'},
                \ {'word': '$_POST', 'kind': 'v'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_complete_variables_from_tags()
    call SetUp()

    " enable variable search in tags
    let g:phpcomplete_search_tags_for_variables = 1
    " set tags to a fixture
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteVariable/tags'

    " disable local variables from current file
    let path =  expand('%:p:h')."/".'fixtures/CompleteVariable/empty.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteVariable('$find_')
    call VUAssertEquals([
                \ {'word': '$find_instance_in_tags', 'info': '$find_instance_in_tags class foo', 'menu': 'foo', 'kind': 'v'},
                \ {'word': '$find_variable_in_tags', 'kind': 'v'}],
                \ res)
    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
