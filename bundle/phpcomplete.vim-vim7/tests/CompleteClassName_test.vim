fun! SetUp()
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1
    " disable builtin information
    let g:php_builtin_classnames = { }
    " disable builtin information
    let g:php_builtin_classes = { }
    " disable builtin information
    let g:php_builtin_interfaces = { }
    " disable tag files
    exe ':set tags='
endf

fun! TestCase_complete_classes_from_current_file()
    call SetUp()

    let path =  expand('%:p:h')."/".'fixtures/CompleteClassName/foo.class.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteClassName('', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'BarClass', 'kind': 'c'},
                \ {'word': 'BarInterface', 'kind': 'i'},
                \ {'word': 'FooClass', 'kind': 'c'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_complete_classes_from_tags()
    call SetUp()

    " set tags to a fixture
    let tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/tags'
    let old_style_tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/old_style_tags'
    exe ':set tags='.tags_path

    " open an empty file so no 'local' class will be picked up
    let path = expand('%:p:h')."/".'fixtures/CompleteClassName/empty.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteClassName('LowerCase', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'lowercasetagclass', 'menu': 'fixtures/CompleteClassName/tagclass.php', 'info': 'fixtures/CompleteClassName/tagclass.php', 'kind': 'c'}],
                \ res, "should match tag classes case insensitive")

    let res = phpcomplete#CompleteClassName('T', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'TagClass', 'menu': 'fixtures/CompleteClassName/tagclass.php', 'info': 'fixtures/CompleteClassName/tagclass.php', 'kind': 'c'}],
                \ res)
    let res = phpcomplete#CompleteClassName('B', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'BarInterface', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'i'}],
                \ res, "should find only interfaces")
    let res = phpcomplete#CompleteClassName('B', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'BarClass', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'c'},
                \ {'word': 'BarInterface', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'i'}],
                \ res, "should find both classes and interfaces in tags")

    " should work just the same with old ctags generated tag files
    exe ':set tags='.old_style_tags_path
    let res = phpcomplete#CompleteClassName('T', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'TagClass', 'menu': 'fixtures/CompleteClassName/tagclass.php', 'info': 'fixtures/CompleteClassName/tagclass.php', 'kind': 'c'}],
                \ res)
    let res = phpcomplete#CompleteClassName('B', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'BarInterface', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'i'}],
                \ res, "should find only interfaces")
    let res = phpcomplete#CompleteClassName('B', ['c', 'i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'BarClass', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'c'},
                \ {'word': 'BarInterface', 'menu': 'fixtures/CompleteClassName/foo.class.php', 'info': 'fixtures/CompleteClassName/foo.class.php', 'kind': 'i'}],
                \ res, "should find both classes and interfaces in tags")

    silent! bw! %
endf

fun! TestCase_complete_classes_from_built_in_classes()
    call SetUp()

    " open an empty file so no 'local' class will be picked up
    let path =  expand('%:p:h')."/".'fixtures/CompleteClassName/empty.php'
    below 1new
    exe ":silent! edit ".path

    " set up example built-in list
    let g:php_builtin_classnames = { 'DateTime':'' }
    let g:php_builtin_classes = {
    \'datetime': {
    \   'name': 'DateTime',
    \   'methods': {
    \   },
    \ },
    \}

    let res = phpcomplete#CompleteClassName('', ['c'], '\', {})
    call VUAssertEquals([
                \ {'word': 'DateTime', 'menu': '', 'kind': 'c'}],
                \ res)

    " user typed \ and hits <c-x><c-o> in a file starting with "namespace NS1;"
    let res = phpcomplete#CompleteClassName('\', ['c'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': '\DateTime', 'menu': '', 'kind': 'c'}],
                \ res)


    " set up example built-in list
    let g:php_builtin_interfaces = {
    \'traversable': {
    \   'name': 'Traversable'
    \ },
    \}

    let res = phpcomplete#CompleteClassName('T', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'Traversable', 'menu': '', 'kind': 'i'}],
                \ res)

    " user typed \T and hits <c-x><c-o> in a file starting with "namespace NS1;"
    let res = phpcomplete#CompleteClassName('\T', ['i'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': '\Traversable', 'menu': '', 'kind': 'i'}],
                \ res)

    let g:php_builtin_interfaces = {
    \'traversable': {
    \   'name': 'FindMeFoo'
    \ },
    \}
    " the completion should give the value of the 'name' property regardless
    " of the outer dictionary keys
    let res = phpcomplete#CompleteClassName('tra', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'FindMeFoo', 'menu': '', 'kind': 'i'}],
                \ res)

    silent! bw! %
endf

fun! TestCase_adds_arguments_of_constructors_for_built_in_classes()
    call SetUp()

    " open an empty file so no 'local' class will be picked up
    let path =  expand('%:p:h')."/".'fixtures/CompleteClassName/empty.php'
    below 1new
    exe ":silent! edit ".path

    " set up example built-in list
    let g:php_builtin_classnames = { 'DateTime':'' }
    let g:php_builtin_classes = {
    \'datetime': {
    \   'name': 'DateTime',
    \   'methods': {
    \     '__construct': { 'signature': '[ string $time = "now" [, DateTimeZone $timezone = NULL]]', 'return_type': ''},
    \   },
    \ },
    \}

    let res = phpcomplete#CompleteClassName('', ['c'], '\', {})
    call VUAssertEquals([
                \ {'word': 'DateTime', 'menu': '[ string $time = "now" [, DateTimeZone $timezone = NULL]]', 'kind': 'c'}],
                \ res)
    silent! bw! %
endf

fun! TestCase_filters_class_names_with_the_namespaces_typed_in_base()
    call SetUp()

    " set tags to a fixture
    let tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/tags'
    let old_style_tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/old_style_tags'
    exe ':set tags='.tags_path

    let res = phpcomplete#CompleteClassName('NS1\N', ['c'], '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\NameSpacedFoo', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'c'}],
                \ res)

    let res = phpcomplete#CompleteClassName('NS1\N', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\NameSpacedFooInterface', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'i'}],
                \ res)

    " with old style ctags, just complete every classame that matches the
    " string after the last \
    exe ':set tags='.old_style_tags_path

    let res = phpcomplete#CompleteClassName('NS1\N', ['c'], '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\NameSpacedFoo', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'c'}],
                \ res)
    let res = phpcomplete#CompleteClassName('NS1\N', ['i'], '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\NameSpacedFooInterface', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'i'}],
                \ res)

    " test for when there are namespaces in the matched tags the non-namespaced
    " matches are thrown out
    exe ':set tags='.old_style_tags_path.','.tags_path
    let res = phpcomplete#CompleteClassName('NS1\NameSpacedF', ['c'], '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\NameSpacedFoo', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'c'}],
                \ res)
endf

fun! TestCase_filters_class_names_with_the_current_namespace_but_doesnt_add_the_current_namespace_to_the_completion_word()
    call SetUp()

    let tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/tags'
    let old_style_tags_path = expand('%:p:h').'/'.'fixtures/CompleteClassName/old_style_tags'
    " set tags to a fixture
    exe ':set tags='.tags_path

    let res = phpcomplete#CompleteClassName('N', ['c'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'NameSpacedFoo', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'c'}],
                \ res)

    let res = phpcomplete#CompleteClassName('N', ['i'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'NameSpacedFooInterface', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'i'}],
                \ res)

    " old style tags
    exe ':set tags='.old_style_tags_path

    let res = phpcomplete#CompleteClassName('N', ['c'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'NameSpacedFoo', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'c'}],
                \ res)

    let res = phpcomplete#CompleteClassName('N', ['i'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'NameSpacedFooInterface', 'menu': 'fixtures/CompleteClassName/namespaced.foo.php', 'info': 'fixtures/CompleteClassName/namespaced.foo.php', 'kind': 'i'}],
                \ res)
endf

fun! TestCase_completes_class_names_from_imported_names()
    call SetUp()

    let res = phpcomplete#CompleteClassName('A', ['c'], 'NS1', {'AO': {'name': 'ArrayObject', 'kind': 'c', 'builtin': 1,}})
    call VUAssertEquals([
                \ {'word': 'AO', 'menu': 'ArrayObject - builtin', 'kind': 'c'}],
                \ res)

    let res = phpcomplete#CompleteClassName('T', ['i'], 'NS1', {'Trav': {'name': 'Traversable', 'kind': 'i', 'builtin': 1,}})
    call VUAssertEquals([
                \ {'word': 'Trav', 'menu': 'Traversable - builtin', 'kind': 'i'}],
                \ res)
endf

fun! TestCase_completes_class_names_from_imported_namespaces_via_tags()
    call SetUp()

    let tags_path = expand('%:p:h').'/'.'fixtures/common/namespaced_foo_tags'
    let old_style_tags_path = expand('%:p:h').'/'.'fixtures/common/old_style_namespaced_foo_tags'

    " set tags to a fixture
    exe ':set tags='.tags_path

    " comlete classes from imported namespace
    let res = phpcomplete#CompleteClassName('SUBNS\F', ['c'], '\', {'SUBNS': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0,}})
    call VUAssertEquals([
                \ {'word': 'SUBNS\FooSub', 'menu': 'fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " comlete classes from imported and renamed namespace, leaving typed in part as-is
    let res = phpcomplete#CompleteClassName('SUB\Fo', ['c'], '\', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0,}})
    call VUAssertEquals([
                \ {'word': 'SUB\FooSub', 'menu': 'fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " comlete classes from absolute namespace prefixes
    let res = phpcomplete#CompleteClassName('\NS1\SUBNS\Fo', ['c'], 'NS1', {})
    call VUAssertEquals([
                \ {'word': '\NS1\SUBNS\FooSub', 'menu': 'fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " set old tags to a fixture
    exe ':set tags='.old_style_tags_path

    " without namespaces in tags, every classname that matches word after the
    " last \ will be returned
    let res = phpcomplete#CompleteClassName('SUBNS\F', ['c'], '\', {'SUBNS': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0,}})
    call VUAssertEquals([
                \ {'word': 'SUBNS\Foo', 'menu': 'fixtures/common/fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/fixtures/common/namespaced_foo.php', 'kind': 'c'},
                \ {'word': 'SUBNS\FooSub', 'menu': 'fixtures/common/fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/fixtures/common/namespaced_foo.php', 'kind': 'c'},
                \ {'word': 'SUBNS\FooSubSub', 'menu': 'fixtures/common/fixtures/common/namespaced_foo.php', 'info': 'fixtures/common/fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
