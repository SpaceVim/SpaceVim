fun! TestCase_returns_instuction_string()
    let path =  expand('%:p:h')."/".'fixtures/GetCurrentInstruction/instructions.php'
    below 1new
    exe ":silent! edit ".path

    call cursor(3, 8)
    let res = phpcomplete#GetCurrentInstruction(3, 8, [1, 1])
    call VUAssertEquals('use Foo1', res, 'should read in the first line as-is')

    call cursor(7, 7)
    let res = phpcomplete#GetCurrentInstruction(7, 7, [1, 1])
    call VUAssertEquals('use Foo2,    Bar', res, 'should return the previous line if the instruction spans multiple line')

    call cursor(12, 7)
    let res = phpcomplete#GetCurrentInstruction(12, 7, [1, 1])
    call VUAssertEquals('use Foo3,        Baz', res, 'should skip content of a comment inside an instruction')

    call cursor(17, 7)
    let res = phpcomplete#GetCurrentInstruction(17, 7, [1, 1])
    call VUAssertEquals('new    Foo', res, 'should simply ignore empty lines')

    call cursor(23, 3)
    let res = phpcomplete#GetCurrentInstruction(23, 3, [1, 1])
    call VUAssertEquals(
                \ '$foo()->bar(        array('';''))->',
                \ res,
                \ 'semicolons in comments or string should be ignored')

    call cursor(37, 6)
    let res = phpcomplete#GetCurrentInstruction(37, 6, [1, 1])
    call VUAssertEquals(
                \ '$some_long_variable->love()->me()->love()->me()->say()->that()->you()->love',
                \ res)

    call cursor(42, 20)
    let res = phpcomplete#GetCurrentInstruction(42, 20, [1, 1])
    call VUAssertEquals(
                \ '$this->foo->',
                \ res)

    call cursor(48, 6)
    let res = phpcomplete#GetCurrentInstruction(48, 6, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)

    call cursor(53, 36)
    let res = phpcomplete#GetCurrentInstruction(53, 36, [1, 1])
    call VUAssertEquals(
                \ '$date->',
                \ res)
    call cursor(55, 38)
    let res = phpcomplete#GetCurrentInstruction(55, 38, [1, 1])
    call VUAssertEquals(
                \ '$date->',
                \ res)
    call cursor(57, 40)
    let res = phpcomplete#GetCurrentInstruction(57, 40, [1, 1])
    call VUAssertEquals(
                \ '$date->',
                \ res)
    call cursor(59, 35)
    let res = phpcomplete#GetCurrentInstruction(59, 35, [1, 1])
    call VUAssertEquals(
                \ '$date->',
                \ res)
    call cursor(64, 28)
    let res = phpcomplete#GetCurrentInstruction(64, 28, [1, 1])
    call VUAssertEquals(
                \ '$bar2->',
                \ res)
    call cursor(65, 46)
    let res = phpcomplete#GetCurrentInstruction(65, 46, [1, 1])
    call VUAssertEquals(
                \ '(new foo)->',
                \ res)
    call cursor(68, 8)
    let res = phpcomplete#GetCurrentInstruction(68, 8, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(70, 8)
    let res = phpcomplete#GetCurrentInstruction(70, 8, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(72, 14)
    let res = phpcomplete#GetCurrentInstruction(72, 14, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(74, 14)
    let res = phpcomplete#GetCurrentInstruction(74, 14, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(76, 28)
    let res = phpcomplete#GetCurrentInstruction(76, 28, [1, 1])
    call VUAssertEquals(
                \ '$baz->',
                \ res)
    call cursor(78, 14)
    let res = phpcomplete#GetCurrentInstruction(78, 14, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(80, 15)
    let res = phpcomplete#GetCurrentInstruction(80, 15, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(82, 16)
    let res = phpcomplete#GetCurrentInstruction(82, 16, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(84, 13)
    let res = phpcomplete#GetCurrentInstruction(84, 13, [1, 1])
    call VUAssertEquals(
                \ '$foo[$bar]->',
                \ res)
    call cursor(86, 12)
    let res = phpcomplete#GetCurrentInstruction(86, 12, [1, 1])
    call VUAssertEquals(
                \ '$bar->',
                \ res)
    call cursor(88, 31)
    let res = phpcomplete#GetCurrentInstruction(88, 31, [1, 1])
    call VUAssertEquals(
                \ 'DateTime::createFromFormat()->',
                \ res)
    call cursor(91, 13)
    let res = phpcomplete#GetCurrentInstruction(91, 13, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(93, 14)
    let res = phpcomplete#GetCurrentInstruction(93, 14, [1, 1])
    call VUAssertEquals(
                \ '$foo->',
                \ res)
    call cursor(96, 48)
    let res = phpcomplete#GetCurrentInstruction(96, 48, [1, 1])
    call VUAssertEquals(
                \ 'class Foo extends Bar implements ArrayAccess, It',
                \ res)

    silent! bw! %
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
