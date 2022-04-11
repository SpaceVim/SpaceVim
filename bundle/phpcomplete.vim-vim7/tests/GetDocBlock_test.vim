fun! SetUp()
    let g:fixture_class_content = readfile(expand('%:p:h').'/'.'fixtures/DocBlock/foo.class.php')[2:]
    let g:phpcomplete_relax_static_constraint = 0
endf

fun! TestCase_returns_empty_string_when_no_comment_block_found()
    call SetUp()

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, 'function\<not_commented\>')
    call VUAssertEquals('', ret)

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, '    public $nocomment;')
    call VUAssertEquals('', ret)
endf

fun! TestCase_returns_the_comment_block_without_last_and_first_line_and_without_leading_stars()
    call SetUp()

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, 'function\s*\<minimally_commented\>')
    call VUAssertEquals(
                \ "minimally_commented",
                \ ret)

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, '    public $foo;')
    call VUAssertEquals(
                \ "@var Foo",
                \ ret)

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, '    public $bar;')
    call VUAssertEquals(
                \ "@type Bar",
                \ ret)
endf

fun! TestCase_recognizes_a_oneline_comment_block_for_properties()
    call SetUp()

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, '    public $onliner;')
    call VUAssertEquals(
                \ "@var Bar",
                \ ret)
endf

fun! TestCase_retuns_docblock_for_the_class_itself()
    call SetUp()

    let ret = phpcomplete#GetDocBlock(g:fixture_class_content, 'class Foo')
    call VUAssertEquals(
                \ "Foo\n\n@property DateTime $baz",
                \ ret)
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
