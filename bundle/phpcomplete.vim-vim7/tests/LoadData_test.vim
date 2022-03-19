fun! SetUp()

endf
fun! TestCase_creates_various_global_hashes()
    call phpcomplete#LoadData()

    call VUAssertTrue(exists('g:php_builtin_classes'))
    call VUAssertTrue(exists('g:php_builtin_classnames'))
    call VUAssertTrue(exists('g:php_builtin_interfaces'))
    call VUAssertTrue(exists('g:php_builtin_interfacenames'))
    call VUAssertTrue(exists('g:php_builtin_functions'))
    call VUAssertTrue(exists('g:php_builtin_vars'))
endf

fun! TestCase_php_built_classnames_and_builtin_classes_are_indexed_lowercase()
    call phpcomplete#LoadData()

    call VUAssertTrue(has_key(g:php_builtin_classes, 'datetime'))
    call VUAssertTrue(has_key(g:php_builtin_classnames, 'datetime'))
    call VUAssertTrue(has_key(g:php_builtin_interfaces, 'traversable'))
    call VUAssertTrue(has_key(g:php_builtin_interfacenames, 'traversable'))
endf

" vim: foldmethod=marker:expandtab:ts=4:sts=4
