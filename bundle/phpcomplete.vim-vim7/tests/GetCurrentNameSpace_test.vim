fun! SetUp()
    exe ':set tags='
endf

fun! TestCase_returns_slash_when_no_namespace_found()
    call SetUp()
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace([])
    call VUAssertEquals('\', namespace)
endf

fun! TestCase_returns_namespace_from_file_lines()
    call SetUp()
    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/single_namespace.php')
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals('Mahou', namespace)

    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/single_namespace2.php')
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals('Mahou', namespace)
endf

fun! TestCase_returns_closest_namespace_from_the_current_line()
    call SetUp()
    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/multiple_namespace.php')
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals('FindMe', namespace)
endf

fun! TestCase_returns_imported_namespaces_and_classes_with_their_info_from_tags()
    call SetUp()

    exe 'set tags='.expand('%:p:h')."/".'fixtures/common/namespaced_foo_tags'
    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/imports.php')

    call phpcomplete#LoadData()

    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals({
                \ 'Foo': {'cmd': '/^class Foo {$/', 'static': 0, 'name': 'Foo', 'namespace': 'NS1', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'},
                \ 'ArrayAccess': {'name': 'ArrayAccess', 'kind': 'i', 'builtin': 1},
                \ 'AO': {'name': 'ArrayObject', 'kind': 'c', 'builtin': 1},
                \ 'DateTimeZone': {'name': 'DateTimeZone', 'kind': 'c', 'builtin': 1},
                \ 'LE': {'name': 'LogicException', 'kind': 'c', 'builtin': 1},
                \ 'DateTime': {'name': 'DateTime', 'kind': 'c', 'builtin': 1},
                \ 'SUBNS': {'cmd': '/^namespace NS1\\SUBNS;$/', 'static': 0, 'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'},
                \ 'EE': {'name': 'ErrorException', 'kind': 'c', 'builtin': 1},
                \ 'E': {'name': 'Exception', 'kind': 'c', 'builtin': 1}},
                \ imports)

    " with old style tags, matching tags with no namespace matches will be returned
    " matching is done regardeless of the namespace we are actually looking
    " for however the desired namespace will be added to the tag
    " namespace import just not recognized with the kind 'n' and filename
    exe 'set tags='.expand('%:p:h')."/".'fixtures/common/old_style_namespaced_foo_tags'
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals({
                \ 'Foo': {'cmd': '/^class Foo {$/', 'static': 0, 'name': 'Foo', 'namespace': 'NS1', 'kind': 'c', 'builtin': 0, 'filename': 'fixtures/common/fixtures/common/namespaced_foo.php'},
                \ 'ArrayAccess': {'name': 'ArrayAccess', 'kind': 'i', 'builtin': 1},
                \ 'AO': {'name': 'ArrayObject', 'kind': 'c', 'builtin': 1},
                \ 'DateTimeZone': {'name': 'DateTimeZone', 'kind': 'c', 'builtin': 1},
                \ 'LE': {'name': 'LogicException', 'kind': 'c', 'builtin': 1},
                \ 'DateTime': {'name': 'DateTime', 'kind': 'c', 'builtin': 1},
                \ 'SUBNS': {'name': 'SUBNS', 'namespace': 'NS1', 'kind': '', 'builtin': 0},
                \ 'EE': {'name': 'ErrorException', 'kind': 'c', 'builtin': 1},
                \ 'E': {'name': 'Exception', 'kind': 'c', 'builtin': 1}},
                \ imports)
endf

fun! TestCase_does_not_pick_up_trait_uses_inside_classes()
    call SetUp()

    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/traits.php')
    call phpcomplete#LoadData()

    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals('NS1', namespace)
    call VUAssertEquals({
                \ 'DateTime': {'name': 'DateTime', 'kind': 'c', 'builtin': 1},
                \}, imports)

endf

fun! TestCase_should_pick_up_imports_regardeless_the_upperlower_case_of_keywords()
    call SetUp()
    call phpcomplete#LoadData()

    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/single_namespace_uppercase.php')
    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals('Mahou', namespace)
    call VUAssertEquals({
                \ 'DT': {'name': 'DateTime', 'kind': 'c', 'builtin': 1}},
                \ imports)
endf

fun! TestCase_should_find_imports_when_called_with_non_balanced_braces()
    call SetUp()

    let file_lines = readfile(expand('%:p:h').'/'.'fixtures/GetCurrentNameSpace/code_blocks.php')[0:7]
    call phpcomplete#LoadData()

    let [namespace, imports] = phpcomplete#GetCurrentNameSpace(file_lines)
    call VUAssertEquals({
                \ 'SomeChildNS': {'name': 'SomeChildNS', 'namespace': 'SomeParentNS', 'kind': '', 'builtin': 0}
                \}, imports)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
