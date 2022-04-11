fun! SetUp()
    " disable builtin information
    let g:php_builtin_classnames = {}
    let g:php_builtin_classes = {}
    let g:php_builtin_interfaces = {}
    let g:php_builtin_interfacenames = {}
    " disable tag files
    exe ':set tags='
endf

fun! TestCase_return_VIMPHP_BUILTINOBJECT_when_classname_in_builtin_classes()
    call SetUp()

    let g:php_builtin_classnames = {'datetime': ''}
    let g:php_builtin_classes = {
                \'datetime':{}
                \}
    let res = phpcomplete#GetClassLocation('DateTime', '')
    call VUAssertEquals('VIMPHP_BUILTINOBJECT', res)

    let res = phpcomplete#GetClassLocation('DateTime', '\')
    call VUAssertEquals('VIMPHP_BUILTINOBJECT', res)
endf

fun! TestCase_return_current_file_path_when_classname_found_in_previous_lines_of_current_buffer()
    call SetUp()

    let path = expand('%:p:h').'/'.'fixtures/GetClassLocation/foo.class.php'
    below 1new
    exe ":silent! edit ".path

    exe ':6'
    let res = phpcomplete#GetClassLocation('Foo', '')
    call VUAssertEquals(path, res)

    exe ':14'
    let res = phpcomplete#GetClassLocation('Foo2', '')
    call VUAssertEquals(path, res)

    exe ':21'
    let res = phpcomplete#GetClassLocation('Foo3', '')
    call VUAssertEquals(path, res)

    silent! bw! %
endf

fun! TestCase_return_class_location_from_tags()
    call SetUp()

    let tags_path = expand('%:p:h').'/'.'fixtures/GetClassLocation/tags'
    let old_style_tags_path = expand('%:p:h').'/'.'fixtures/GetClassLocation/old_style_tags'
    let path = expand('%:p:h').'/'.'fixtures/GetClassLocation/empty.php'

    exe ':set tags='.tags_path
    below 1new
    exe ":silent! edit ".path
    exe ':3'

    let res = phpcomplete#GetClassLocation('Foo', '')
    call VUAssertEquals('fixtures/GetClassLocation/foo.class.php', res)

    let res = phpcomplete#GetClassLocation('FooInterface', '')
    call VUAssertEquals('fixtures/GetClassLocation/foo.class.php', res)

    let res = phpcomplete#GetClassLocation('FooTrait', '')
    call VUAssertEquals('fixtures/GetClassLocation/foo.class.php', res)

    " when there are no namespaces to match for the classes from the tags file
    " should return the first class's location where the name matches
    exe ':set tags='.old_style_tags_path
    let res = phpcomplete#GetClassLocation('Foo', '')
    call VUAssertEquals('fixtures/GetClassLocation/foo.class.php', res)

    let res = phpcomplete#GetClassLocation('FooInterface', '')
    call VUAssertEquals('fixtures/GetClassLocation/foo.class.php', res)

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
