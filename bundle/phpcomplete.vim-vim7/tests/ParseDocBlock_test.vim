fun! SetUp()
endf

fun! TestCase_collects_lines_up_until_the_first_param_var_or_return_as_description_whitespace_trimmed_down_from_the_ends()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock(
                \ "short description\n".
                \ "\n".
                \ "long description line\n".
                \ "long description line2\n".
                \ "@return Foo some foo\n".
                \ "not included in description\n")

    call VUAssertEquals("".
                \ "short description\n".
                \ "\n".
                \ "long description line\n".
                \ "long description line2",
                \ ret.description)
endf

fun! TestCase_extracts_return_type_and_description()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock("@return Foo some foo\n")
    call VUAssertEquals("Foo", ret.return.type)
    call VUAssertEquals("some foo", ret.return.description)

    " description is empty string when not specified
    let ret = phpcomplete#ParseDocBlock("@return Foo\n")
    call VUAssertEquals("Foo", ret.return.type)
    call VUAssertEquals("", ret.return.description)
endf

fun! TestCase_extracts_parameters_with_types_and_descriptions()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock("".
                \ "@param mixed $foo\n".
                \ "@param Foo $bar some description\n")

    call VUAssertEquals("mixed", ret.params[0].type)
    call VUAssertEquals("$foo",  ret.params[0].name)
    call VUAssertEquals("",      ret.params[0].description)

    call VUAssertEquals("Foo", ret.params[1].type)
    call VUAssertEquals("$bar", ret.params[1].name)
    call VUAssertEquals("some description", ret.params[1].description)
endf

fun! TestCase_extracts_throws_and_exception_lines_with_type_and_description()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock("".
                \ "@exception Foo on full moons\n".
                \ "@throws Foo\n")

    call VUAssertEquals("Foo", ret.throws[0].type)
    call VUAssertEquals("on full moons", ret.throws[0].description)

    call VUAssertEquals("Foo", ret.throws[1].type)
    call VUAssertEquals("", ret.throws[1].description)
endf

fun! TestCase_extracts_var_lines_with_type_and_description()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock("@var Foo some description\n")
    call VUAssertEquals("Foo", ret.var.type)
    call VUAssertEquals("some description", ret.var.description)

    let ret = phpcomplete#ParseDocBlock("@var Foo\n")
    call VUAssertEquals("Foo", ret.var.type)
    call VUAssertEquals("", ret.var.description)
endf

fun! TestCase_extracts_AT_properties_from_docblock_of_a_class()
    call SetUp()

    let ret = phpcomplete#ParseDocBlock("Foo\n\n@property DateTime $baz Some comments here")
    call VUAssertEquals([{'description': '$baz Some comments here', 'line': '@property DateTime $baz Some comments here', 'type': 'DateTime'}], ret.properties)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
