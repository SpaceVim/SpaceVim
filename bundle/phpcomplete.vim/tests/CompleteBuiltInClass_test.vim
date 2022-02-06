fun! TestCase_returns_methods()
    " setup
    let g:php_builtin_classes = {
    \'datetime': {
    \   'name': 'DateTime',
    \   'constants': {
    \   },
    \   'properties': {
    \   },
    \   'static_properties': {
    \   },
    \   'methods': {
    \     '__construct': { 'signature': '[ string $time = "now" [, DateTimeZone $timezone = NULL]]', 'return_type': ''},
    \     'add': { 'signature': 'DateInterval $interval | DateTime', 'return_type': 'DateTime'},
    \   },
    \   'static_methods': {
    \   },
    \},
    \}
    let ret = phpcomplete#CompleteBuiltInClass('$d->', 'DateTime', 'add')
    call VUAssertEquals(1, len(ret))
    call VUAssertEquals([{
                \ 'word': 'add(',
                \ 'menu': 'DateInterval $interval | DateTime', 'info': 'DateInterval $interval | DateTime',
                \ 'kind': 'f'}],
                \ ret)
endfun

fun! TestCase_returns_properties()
    " setup
    let g:php_builtin_classes = {
    \'domdocument': {
    \   'name': 'DOMDocument',
    \   'constants': {
    \   },
    \   'properties': {
    \     'encoding': { 'initializer': '', 'type': 'string'},
    \   },
    \   'static_properties': {
    \   },
    \   'methods': {
    \   },
    \   'static_methods': {
    \   },
    \},
    \}
    let ret = phpcomplete#CompleteBuiltInClass('$dom->', 'DOMDocument', 'enc')
    call VUAssertEquals(1, len(ret))
    call VUAssertEquals([{
                \ 'word': 'encoding',
                \ 'menu': 'string',
                \ 'info': 'string',
                \ 'kind': 'v'}],
                \ ret)
endfun

fun! TestCase_returns_static_methods()
    " setup
    let g:php_builtin_classes = {
    \'datetime': {
    \   'name': 'DateTime',
    \   'constants': {
    \   },
    \   'properties': {
    \   },
    \   'static_properties': {
    \   },
    \   'methods': {
    \   },
    \   'static_methods': {
    \     'createFromFormat': { 'signature': 'string $format, string $time [, DateTimeZone $timezone] | DateTime', 'return_type': 'DateTime'},
    \   },
    \},
    \}
    let ret = phpcomplete#CompleteBuiltInClass('DateTime::', 'DateTime', 'create')
    call VUAssertEquals(1, len(ret))
    call VUAssertEquals([{
                \ 'word': 'createFromFormat(',
                \ 'menu': 'string $format, string $time [, DateTimeZone $timezone] | DateTime',
                \ 'info': 'string $format, string $time [, DateTimeZone $timezone] | DateTime',
                \ 'kind': 'f'}],
                \ ret)
endfun

fun! TestCase_returns_static_properties()
    " setup
    let g:php_builtin_classes = {
    \'mongocursor': {
    \   'name': 'MongoCursor',
    \   'constants': {
    \   },
    \   'properties': {
    \   },
    \   'static_properties': {
    \     '$timeout': { 'initializer': '20000', 'type': 'integer'},
    \   },
    \   'methods': {
    \   },
    \   'static_methods': {
    \   },
    \},
    \}
    let ret = phpcomplete#CompleteBuiltInClass('MongoCursor::', 'MongoCursor', '$tim')
    call VUAssertEquals(1, len(ret))
    call VUAssertEquals([{
                \ 'word': '$timeout',
                \ 'menu': 'integer',
                \ 'info': 'integer',
                \ 'kind': 'v'}],
                \ ret)
endfun

fun! TestCase_returns_constants()
    " setup
    let g:php_builtin_classes = {
    \ 'datetime': {
    \   'name': 'DateTime',
    \   'constants': {
    \     'ATOM': '"Y-m-d\TH:i:sP"',
    \   },
    \   'properties': {
    \   },
    \   'static_properties': {
    \   },
    \   'methods': {
    \   },
    \   'static_methods': {
    \   },
    \},
    \}
    let ret = phpcomplete#CompleteBuiltInClass('Datetime::', 'DateTime', 'ATO')
    call VUAssertEquals(1, len(ret))
    call VUAssertEquals([{
                \ 'word': 'ATOM',
                \ 'menu': '"Y-m-d\TH:i:sP"',
                \ 'info': '"Y-m-d\TH:i:sP"',
                \ 'kind': 'd'}],
                \ ret)
endfun

" vim: foldmethod=marker:expandtab:ts=4:sts=4
