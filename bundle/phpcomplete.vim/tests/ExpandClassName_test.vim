fun! SetUp()
    exe ':set tags='
endf

fun! TestCase_removes_leading_slash()
    call SetUp()

    let [classname, namespace] = phpcomplete#ExpandClassName('\ArrayObject', '\', {})
    call VUAssertEquals('ArrayObject', classname)

    let [classname, namespace] = phpcomplete#ExpandClassName('ArrayObject', '\Mahou', {})
    call VUAssertEquals('ArrayObject', classname)
    call VUAssertEquals('Mahou', namespace)
endf

fun! TestCase_appends_relative_namespace_parts_from_classname_to_current_namespace()
    call SetUp()

    let [classname, namespace] = phpcomplete#ExpandClassName('Baz\Foo', 'Bor\Bar', {})
    call VUAssertEquals('Foo', classname)
    call VUAssertEquals('Bor\Bar\Baz', namespace)
endf

fun! TestCase_extracts_namespace_from_classname_when_its_prefixed_with_absolute_namespace()
    call SetUp()

    let [classname, namespace] = phpcomplete#ExpandClassName('\Bar\Baz\Foo', 'Mahou', {})
    call VUAssertEquals('Foo', classname)
    call VUAssertEquals('Bar\Baz', namespace)
endf

fun! TestCase_matches_classname_from_imported_names()
    call SetUp()

    " imported builtin
    let [classname, namespace] = phpcomplete#ExpandClassName('AO', 'Mahou', {'AO': {'name': 'ArrayObject', 'kind': 'c', 'builtin': 1,}})
    call VUAssertEquals(['ArrayObject', ''], [classname, namespace])

    " imported user class
    let [classname, namespace] = phpcomplete#ExpandClassName('Foo', 'Mahou', {'Foo': {'name': 'Foo', 'kind': 'c', 'builtin': 0, 'namespace': 'NS1'}})
    call VUAssertEquals(['Foo', 'NS1'], [classname, namespace])

    " imported user interface
    let [classname, namespace] = phpcomplete#ExpandClassName('FooInterface', 'Mahou', {'FooInterface': {'name': 'FooInterface', 'kind': 'i', 'builtin': 0, 'namespace': 'NS1'}})
    call VUAssertEquals(['FooInterface', 'NS1'], [classname, namespace])

    " imported user trait
    let [classname, namespace] = phpcomplete#ExpandClassName('FooTrait', 'Mahou', {'FooTrait': {'name': 'FooTrait', 'kind': 't', 'builtin': 0, 'namespace': 'NS2'}})
    call VUAssertEquals(['FooTrait', 'NS2'], [classname, namespace])
endf

fun! TestCase_matches_namespace_from_imported_names()
    " class in imported namespace
    let [classname, namespace] = phpcomplete#ExpandClassName('SUBNS\FooSub', 'Mahou', {'SUBNS': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0,}})
    call VUAssertEquals(['FooSub', 'NS1\SUBNS'], [classname, namespace])

    " class in imported and renamed namespace
    let [classname, namespace] = phpcomplete#ExpandClassName('SUB\FooSub', 'Mahou', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0,}})
    call VUAssertEquals(['FooSub', 'NS1\SUBNS'], [classname, namespace])
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
