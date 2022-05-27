fun! TestCase_returns_zero_when_no_function_found_above()

    let path =  expand('%:p:h')."/".'fixtures/GetCurrentFunctionBoundaries/test.php'
    below 1new
    exe ":silent! edit ".path

	exe ':3'
    let res = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals(0, res, "should return zero for top level code")

	exe ':10'
    let res2 = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals(0, res2, "should return zero for top level code even if there's a function above it")

	exe ':7'
    let res3 = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals([[5, 1], [8, 1]], res3)

	exe ':17'
    let res4 = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals([[14, 2], [18, 2]], res4)

	exe ':32'
    let res6 = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals([[31, 1], [33, 0]], res6)

    " fails with the dist version
    exe ':28'
    let res5 = phpcomplete#GetCurrentFunctionBoundaries()
    call VUAssertEquals([[21, 1], [29, 1]], res5)

    silent! bw! %
endf
