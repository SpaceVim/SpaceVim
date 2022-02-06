fun! SetUp()
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/tags'
    let g:php_builtin_classes = {}
    let g:php_builtin_classnames = {}
    let g:php_builtin_interfacenames = {}
    let g:php_builtin_interfaces = {}
endf

fun! TestCase_reads_in_the_class_from_the_list_of_lines()
    call SetUp()

    let location =  expand('%:p:h')."/".'fixtures/GetClassContents/foo.class.php'
    let contents = phpcomplete#GetClassContents(location, 'FooClass')
    let expected = join(readfile(location)[1:], "\n")
    call VUAssertEquals(expected, contents)

    let location =  expand('%:p:h')."/".'fixtures/GetClassContents/foo_whitespace.class.php'
    let contents = phpcomplete#GetClassContents(location, 'FooClass')
    let expected = join(readfile(location)[4:9], "\n")
    call VUAssertEquals(expected, contents)

    let location =  expand('%:p:h')."/".'fixtures/GetClassContents/foo.interface.php'
    let contents = phpcomplete#GetClassContents(location, 'FooInterface')
    let expected = join(readfile(location)[1:], "\n")
    call VUAssertEquals(expected, contents)
endf

fun! TestCase_only_reads_in_the_class_content()
    call SetUp()

    let location =  expand('%:p:h')."/".'fixtures/GetClassContents/foo_with_extra_content.class.php'
    let contents = phpcomplete#GetClassContents(location, 'FooClass')
    let expected = join(readfile(location)[5:8], "\n")
    call VUAssertEquals(expected, contents)
endf

fun! TestCase_reads_in_the_extended_class_content()
    call SetUp()

    " tags used to find the extended classes
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/tags'
    let location         =  expand('%:p:h')."/".'fixtures/GetClassContents/extends/foo_extends_bar.class.php'
    let extends_location =  expand('%:p:h')."/".'fixtures/GetClassContents/extends/bar.class.php'

    let contents = phpcomplete#GetClassContents(location, 'FooClass')

    let expected = readfile(location)[2]."\n".readfile(extends_location)[2]
    call VULog(expected)

    call VUAssertEquals(expected, contents)
endf

fun! TestCase_reads_in_the_extended_classes_recursive()
    call SetUp()

    " tags used to find the extended classes
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/tags'
    let location                 =  expand('%:p:h')."/".'fixtures/GetClassContents/extends_extends/foo2_extends_bar2.class.php'
    let extends_location         =  expand('%:p:h')."/".'fixtures/GetClassContents/extends_extends/bar2_extends_baz.class.php'
    let extends_extends_location =  expand('%:p:h')."/".'fixtures/GetClassContents/extends_extends/baz.class.php'

    let expected  = readfile(location)[2]."\n"
    let expected .= readfile(extends_location)[2]."\n"
    let expected .= readfile(extends_extends_location)[2]
    call VULog(expected)

    let contents = phpcomplete#GetClassContents(location, 'FooClass2')
    call VUAssertEquals(expected, contents)
endf

fun! TestCase_reads_in_the_extended_classes_recursive_with_namespaces()
    call SetUp()

    " tags used to find the extended classes
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/tags'
    let location         =  expand('%:p:h')."/".'fixtures/GetClassContents/ns1_foo2.php'
    let extends_location =  expand('%:p:h')."/".'fixtures/GetClassContents/ns2_foo.php'

    let expected  = readfile(location)[3]."\n"
    let expected .= readfile(extends_location)[3]
    call VULog(expected)

    let contents = phpcomplete#GetClassContents(location, 'NamespacedFoo2')
    call VUAssertEquals(expected, contents)
endf

fun! TestCase_reads_in_the_extended_classes_with_imports()
    call SetUp()

    " tags used to find the extended classes
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/import/tags'
    let g:php_builtin_classes = {}
    let location         =  expand('%:p:h')."/".'fixtures/GetClassContents/import/ns1_foo2.php'
    let extends_location =  expand('%:p:h')."/".'fixtures/GetClassContents/import/ns2_foo.php'

    let expected  = readfile(location)[4]."\n"
    let expected .= readfile(extends_location)[3]
    call VULog(expected)

    let contents = phpcomplete#GetClassContents(location, 'NamespacedFoo2')
    call VUAssertEquals(expected, contents)
endf

fun! TestCase_handles_matching_class_name_extends_with_different_namespaces()
    call SetUp()

    " tags used to find the extended classes
    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/same_classname/tags'
    let location         =  expand('%:p:h')."/".'fixtures/GetClassContents/same_classname/foo.class.php'
    let extends_location =  expand('%:p:h')."/".'fixtures/GetClassContents/same_classname/ns1_foo.class.php'

    let class_contents = readfile(location)[2:10]
    let expected  = join(class_contents, "\n")."\n"
    let expected .= readfile(extends_location)[4]

    below 1new
    exe ":silent! edit ".location

    exe ':7'
    let structure = phpcomplete#GetClassContentsStructure(location, class_contents, 'Foo')
    call VUAssertEquals(expected, structure[0].content."\n".structure[1].content)

    silent! bw! %
endf

" fails with the dist version
fun! TestCase_returns_contents_of_a_class_regardless_of_comments_or_strings()
    let path1 =  expand('%:p:h')."/".'fixtures/GetClassContents/foo2.class.php'
    let expected1 = join(readfile(path1)[2:12], "\n")
    let contents1 = readfile(path1)

    below 1new
    exe ":silent! edit ".path1

    let structure = phpcomplete#GetClassContentsStructure(path1, contents1, 'Foo2')
    call VUAssertEquals(expected1, structure[0].content)

    silent! bw! %
endf

fun! TestCase_returns_contents_of_used_traits_too()
    call SetUp()

    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/tags'
    let path1 =  expand('%:p:h')."/".'fixtures/GetClassContents/foo3.class.php'
    let path2 =  expand('%:p:h')."/".'fixtures/GetClassContents/foo.trait.php'
    let expected = join(readfile(path1)[2:7], "\n")."\n".join(readfile(path2)[2:4], "\n")

    below 1new
    exe ":silent! edit ".path1

    let contents = phpcomplete#GetClassContents(path1, 'Foo3')
    call VUAssertEquals(expected, contents)

    silent! bw! %
endf

fun! TestCase_returns_class_content_from_inside_the_same_file()
    call SetUp()

    let location = expand('%:p:h')."/".'fixtures/GetClassContents/same_file_class.php'
    let class_contents = readfile(location)[4:6]
    let expected  = join(class_contents, "\n")."\n"
    let expected .= readfile(location)[2]
    let expected2 = join(readfile(location)[8:10], "\n")

    below 1new
    exe ":silent! edit ".location

    " Even if there's no tags or other help to locate the extended class, the
    " plugin should try to find it in the same file that the extending class
    " located
    exe ':8'
    let structure = phpcomplete#GetClassContentsStructure(location, readfile(location), 'SomeTraitedClass')
    call VUAssertEquals(expected, structure[0].content."\n".structure[1].content)

    " The function should just skip any non-locatable extended class
    exe ':12'
    let structure = phpcomplete#GetClassContentsStructure(location, readfile(location), 'ExtendsNonExistsing')
    call VUAssertEquals(expected2, structure[0].content)

    silent! bw! %
endf

fun! TestCase_returns_contents_of_implemented_interfaces()
    call SetUp()

    exe 'set tags='.expand('%:p:h')."/".'fixtures/GetClassContents/interface_tags'
    let path1 =  expand('%:p:h')."/".'fixtures/GetClassContents/interfaces.php'
    let path2 =  expand('%:p:h')."/".'fixtures/GetClassContents/implements.php'
    let expected  = join(readfile(path2)[2:3], "\n")."\n".join(readfile(path1)[2:3], "\n")
    let expected2 = join(readfile(path2)[5:6], "\n")."\n".join(readfile(path1)[2:3], "\n")."\n".join(readfile(path1)[5:6], "\n")

    below 1new
    exe ":silent! edit ".path2

    let contents = phpcomplete#GetClassContents(path2, 'X')
    call VUAssertEquals(expected, contents)

    let contents2 = phpcomplete#GetClassContents(path2, 'Y')
    call VUAssertEquals(expected2, contents2)

    silent! bw! %
endf

fun! TestCase_returns_the_contents_of_extended_interfaces()
    call SetUp()

    exe 'set tags='
    let path = expand('%:p:h')."/".'fixtures/GetClassContents/interfaces.php'

    below 1new
    exe ":silent! edit ".path

    let contents = phpcomplete#GetClassContentsStructure(path, readfile(path), 'FooFoo2')
    call VUAssertEquals('FooFoo2', contents[0].class)
    call VUAssertEquals('Foo',     contents[1].class)
    call VUAssertEquals('Foo2',    contents[2].class)

    silent! bw! %
endf

fun! TestCase_returns_the_contents_of_extended_interfaces()
    call SetUp()

    exe 'set tags='
    let path = expand('%:p:h')."/".'fixtures/GetClassContents/docblocked_foo.php'
    let expected  = join(readfile(path)[2:], "\n")

    below 1new
    exe ":silent! edit ".path

    let contents = phpcomplete#GetClassContentsStructure(path, readfile(path), 'DocBlockedFoo')
    call VUAssertEquals(expected, contents[0].content, "Should read class contents with it's docblock")

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
