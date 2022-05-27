fun! SetUp()
    " disable built-in classes
    let g:php_builtin_classnames = {}
    " disable built-in interfaces
    let g:php_builtin_interfacenames = {}
    " disable built-in functions
    let g:php_builtin_functions = {}
    " disable built-in constants
    let g:php_constants = {}
    " disable php keywords
    let g:php_keywords = {}
    " disable tags
    exe ':set tags='
    " set related options to it's default
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1
endf

fun! TestCase_completes_functions_from_local_file() " {{{
    call SetUp()
    " load fixture with methods and functions in it
    let path =  expand('%:p:h').'/'.'fixtures/CompleteGeneral/functions.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteGeneral('common_', '\', {})

    call VUAssertEquals([
                \ {'word': 'common_plain_old_function('               , 'info': 'common_plain_old_function()'                          , 'menu': ')',          'kind': 'f'},
                \ {'word': 'common_plain_old_function_with_arguments(', 'info': "common_plain_old_function_with_arguments($a, $b='')"  , 'menu': "$a, $b='')", 'kind': 'f'},
                \ {'word': 'common_private_method('                   , 'info': 'common_private_method($foo)'                          , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_private_static_method('            , 'info': 'common_private_static_method($foo)'                   , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_protected_method('                 , 'info': 'common_protected_method($foo)'                        , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_protected_static_method('          , 'info': 'common_protected_static_method($foo)'                 , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_public_method('                    , 'info': 'common_public_method($foo)'                           , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_public_static_method('             , 'info': 'common_public_static_method($foo)'                    , 'menu': '$foo)',      'kind': 'f'},
                \ {'word': 'common_static_public_method('             , 'info': 'common_static_public_method($foo)'                    , 'menu': '$foo)',      'kind': 'f'}],
                \ res)
    silent! bw! %
endf " }}}

fun! TestCase_completes_functions_classes_constants_constants_from_tags() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/tags'
    let res = phpcomplete#CompleteGeneral('common', '\', {})

    call VUAssertEquals([
                \ {'word': 'COMMON_FOO',                                'info': 'COMMON_FOO - fixtures/CompleteGeneral/foo.php',                                          'menu': ' - fixtures/CompleteGeneral/foo.php',           'kind': 'd'},
                \ {'word': 'CommonFoo',                                 'info': 'CommonFoo - fixtures/CompleteGeneral/foo.php',                                           'menu': ' - fixtures/CompleteGeneral/foo.php',           'kind': 'c'},
                \ {'word': 'CommonTrait',                               'info': ' - fixtures/CompleteGeneral/foo.php',                                                    'menu': ' - fixtures/CompleteGeneral/foo.php',           'kind': 't'},
                \ {'word': 'common_plain_old_function(',                'info': 'common_plain_old_function() - fixtures/CompleteGeneral/foo.php',                         'menu': ') - fixtures/CompleteGeneral/foo.php',          'kind': 'f'},
                \ {'word': 'common_plain_old_function_with_arguments(', 'info': "common_plain_old_function_with_arguments($a, $b='') - fixtures/CompleteGeneral/foo.php", 'menu': "$a, $b='') - fixtures/CompleteGeneral/foo.php", 'kind': 'f'},
                \ {'word': 'common_private_method(',                    'info': 'common_private_method($foo) - fixtures/CompleteGeneral/foo.php',                         'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_private_static_method(',             'info': 'common_private_static_method($foo) - fixtures/CompleteGeneral/foo.php',                  'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_protected_method(',                  'info': 'common_protected_method($foo) - fixtures/CompleteGeneral/foo.php',                       'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_protected_static_method(',           'info': 'common_protected_static_method($foo) - fixtures/CompleteGeneral/foo.php',                'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_public_method(',                     'info': 'common_public_method($foo) - fixtures/CompleteGeneral/foo.php',                          'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_public_static_method(',              'info': 'common_public_static_method($foo) - fixtures/CompleteGeneral/foo.php',                   'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'},
                \ {'word': 'common_static_public_method(',              'info': 'common_static_public_method($foo) - fixtures/CompleteGeneral/foo.php',                   'menu': '$foo) - fixtures/CompleteGeneral/foo.php',      'kind': 'f'}],
                \ res)
endf " }}}

fun! TestCase_completes_function_signature_from_tags_if_field_available() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/patched_tags'
    let res = phpcomplete#CompleteGeneral('common_plain_old_function_with_', '\', {})

    call VUAssertEquals([
                \ {'word': 'common_plain_old_function_with_arguments(', 'info': "common_plain_old_function_with_arguments($a, $b = '') - fixtures/CompleteGeneral/functions.php", 'menu': "$a, $b = '') - fixtures/CompleteGeneral/functions.php", 'kind': 'f'}],
                \ res)
endf " }}}

fun! TestCase_completes_constants_from_local_file() " {{{
    call SetUp()
    " load fixture with methods and functions in it
    let path =  expand('%:p:h').'/'.'fixtures/CompleteGeneral/constants.php'
    below 1new
    exe ":silent! edit ".path

    let res = phpcomplete#CompleteGeneral('FIND', '\', {})

    call VUAssertEquals([
                \ {'word': 'FINDME_FOO', 'kind': 'd', 'menu': '', 'info': 'FINDME_FOO'}],
                \ res)
    silent! bw! %
endf " }}}

fun! TestCase_completes_builtin_functions() " {{{
    call SetUp()

    " the filter_* one should not be picked up
    let g:php_builtin_functions = {
                \ 'array_flip(': 'array $trans | array',
                \ 'array_product(': 'array $array | number',
                \ 'filter_var(': 'mixed $variable [, int $filter = FILTER_DEFAULT [, mixed $options]] | mixed',
                \ }

    let res = phpcomplete#CompleteGeneral('array_', '\', {})
    call VUAssertEquals([
                \ {'word': 'array_flip(',    'info': 'array_flip(array $trans | array',     'menu': 'array $trans | array',  'kind': 'f'},
                \ {'word': 'array_product(', 'info': 'array_product(array $array | number', 'menu': 'array $array | number', 'kind': 'f'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_constants() " {{{
    call SetUp()

    " the FILE_* ones should not be picked up
    let g:php_constants = {
                \ 'FILE_TEXT': '',
                \ 'FILE_USE_INCLUDE_PATH': '',
                \ 'FILTER_CALLBACK': '',
                \ 'FILTER_DEFAULT': '',
                \ }

    let res = phpcomplete#CompleteGeneral('FILTER_', '\', {})
    call VUAssertEquals([
                \ {'word': 'FILTER_CALLBACK', 'kind': 'd', 'menu': ' - builtin', 'info': 'FILTER_CALLBACK - builtin'},
                \ {'word': 'FILTER_DEFAULT', 'kind': 'd', 'menu': ' - builtin', 'info': 'FILTER_DEFAULT - builtin'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_keywords() " {{{
    call SetUp()

    let g:php_keywords = {
                \ 'argv':'',
                \ 'argc':'',
                \ 'and':'',
                \ }

    let res = phpcomplete#CompleteGeneral('a', '\', {})
    call VUAssertEquals([
                \ {'word': 'and'},
                \ {'word': 'argc'},
                \ {'word': 'argv'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_class_names() " {{{
    call SetUp()

    " PDO should not be picked up
    let g:php_builtin_classnames = {
                \ 'datetime':'',
                \ 'pdo':'',
                \ }

    let g:php_builtin_classes = {
                \ 'datetime':{
                \   'name': 'DateTime',
                \ },
                \ 'pdo':{
                \   'name': 'PDO',
                \ }
                \ }

    let res = phpcomplete#CompleteGeneral('date', '\', {})
    call VUAssertEquals([
                \ {'word': 'DateTime', 'kind': 'c', 'menu': ' - builtin', 'info': 'DateTime - builtin'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_interface_names() " {{{
    call SetUp()

    " PDO should not be picked up
    let g:php_builtin_interfacenames = {
                \ 'traversable':'',
                \ }
    let g:php_builtin_interfaces = {
                \ 'traversable':{
                \   'name': 'Traversable',
                \ }
                \ }

    let res = phpcomplete#CompleteGeneral('Tr', '\', {})
    call VUAssertEquals([
                \ {'word': 'Traversable', 'kind': 'i', 'menu': ' - builtin', 'info': 'Traversable - builtin'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_functions_when_in_namespace() " {{{
    call SetUp()

    " the filter_* one should not be picked up
    let g:php_builtin_functions = {
                \ 'array_flip(': 'array $trans | array',
                \ 'array_product(': 'array $array | number',
                \ 'filter_var(': 'mixed $variable [, int $filter = FILTER_DEFAULT [, mixed $options]] | mixed',
                \ }

    " should find completions when base prefixed with \
    let res = phpcomplete#CompleteGeneral('\array_', 'SomeNameSpace', {})
    call VUAssertEquals([
                \ {'word': '\array_flip(',    'info': '\array_flip(array $trans | array',     'menu': 'array $trans | array',  'kind': 'f'},
                \ {'word': '\array_product(', 'info': '\array_product(array $array | number', 'menu': 'array $array | number', 'kind': 'f'}],
                \ res)

    " should find completions even without \ in the beginning of base
    let res = phpcomplete#CompleteGeneral('array_', 'SomeNameSpace', {})
    call VUAssertEquals([
                \ {'word': 'array_flip(',    'info': 'array_flip(array $trans | array',     'menu': 'array $trans | array',  'kind': 'f'},
                \ {'word': 'array_product(', 'info': 'array_product(array $array | number', 'menu': 'array $array | number', 'kind': 'f'}],
                \ res)
endf " }}}

fun! TestCase_completes_builtin_constants_when_in_namespace() " {{{
    call SetUp()

    " the FILE_* ones should not be picked up
    let g:php_constants = {
                \ 'FILE_TEXT': '',
                \ 'FILE_USE_INCLUDE_PATH': '',
                \ 'FILTER_CALLBACK': '',
                \ 'FILTER_DEFAULT': '',
                \ }

    " should find completions when base prefixed with \
    let res = phpcomplete#CompleteGeneral('\FILTER_', 'SomeNameSpace', {})
    call VUAssertEquals([
                \ {'word': '\FILTER_CALLBACK', 'kind': 'd', 'info': '\FILTER_CALLBACK - builtin', 'menu': ' - builtin'},
                \ {'word': '\FILTER_DEFAULT', 'kind': 'd', 'info': '\FILTER_DEFAULT - builtin', 'menu': ' - builtin'}],
                \ res)

    " should find completions even without \ in the beginning of base
    let res = phpcomplete#CompleteGeneral('FILTER_', 'SomeNameSpace', {})
    call VUAssertEquals([
                \ {'word': 'FILTER_CALLBACK', 'kind': 'd', 'info': 'FILTER_CALLBACK - builtin', 'menu': ' - builtin'},
                \ {'word': 'FILTER_DEFAULT', 'kind': 'd', 'info': 'FILTER_DEFAULT - builtin', 'menu': ' - builtin'}],
                \ res)

endf " }}}

fun! TestCase_doesnt_complete_keywords_when_theres_a_leading_slash() " {{{
    call SetUp()

    let g:php_keywords = {
                \ 'argv':'',
                \ 'argc':'',
                \ 'and':'',
                \ }

    let res = phpcomplete#CompleteGeneral('\a', '\', {})
    call VUAssertEquals([], res)
endf " }}}

fun! TestCase_completes_builtin_class_names_when_in_namespace_and_base_starts_with_slash() " {{{
    call SetUp()

    " PDO should not be picked up
    let g:php_builtin_classnames = {
                \ 'datetime':'',
                \ 'pdo':'',
                \ }
    let g:php_builtin_classes = {
                \ 'datetime':{
                \   'name': 'DateTime',
                \ },
                \ 'pdo':{
                \   'name': 'PDO',
                \ }
                \ }

    let res = phpcomplete#CompleteGeneral('\date', 'SomeNameSpace', {})
    call VUAssertEquals([
                \ {'word': '\DateTime', 'kind': 'c', 'info': '\DateTime - builtin', 'menu': ' - builtin'}],
                \ res)
endf " }}}

fun! TestCase_completes_namespace_names_from_tags() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/namespaced_tags'

    let res = phpcomplete#CompleteGeneral('NS', '\', {})
    call VUAssertEquals([
                \ {'word': 'NS1\', 'menu': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'},
                \ {'word': 'NS1\SUBNS\', 'menu': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'},
                \ {'word': 'NS1\SUBNS\SUBSUB\', 'menu': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'}],
                \ res)

   let res = phpcomplete#CompleteGeneral('\NS', 'SomeNameSpace', {})
   call VUAssertEquals([
               \ {'word': '\NS1\', 'kind': 'n', 'menu': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php'},
               \ {'word': '\NS1\SUBNS\', 'kind': 'n', 'menu': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php'},
               \ {'word': '\NS1\SUBNS\SUBSUB\', 'kind': 'n', 'menu': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php'}],
               \ res)

   " leaves leading slash if you have typed that in
   let res = phpcomplete#CompleteGeneral('\NS', '\', {})
   call VUAssertEquals([
               \ {'word': '\NS1\', 'menu': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1 - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'},
               \ {'word': '\NS1\SUBNS\', 'menu': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'},
               \ {'word': '\NS1\SUBNS\SUBSUB\', 'menu': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'n'}],
               \ res)

   " completes namespaces relative to the current namespace
   let res = phpcomplete#CompleteGeneral('SUB', 'NS1', {})
   call VUAssertEquals([
               \ {'word': 'SUBNS\', 'kind': 'n', 'menu': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS - fixtures/CompleteGeneral/namespaced_foo.php'},
               \ {'word': 'SUBNS\SUBSUB\', 'kind': 'n', 'menu': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'NS1\SUBNS\SUBSUB - fixtures/CompleteGeneral/namespaced_foo.php'}],
               \ res)
endf " }}}

fun! TestCase_completes_class_names_from_tags_matching_namespaces() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/namespaced_tags'

    " this is where class name part must have at least the configured amount
    " of letters to start matching
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1

    let res = phpcomplete#CompleteGeneral('F', 'NS1', {})
    call VUAssertEquals([{'word': 'Foo', 'kind': 'c', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'Foo - fixtures/CompleteGeneral/namespaced_foo.php'}], res)

    " leaves typed in namespace even when its the same we are in
    let res = phpcomplete#CompleteGeneral('\NS1\F', 'NS1', {})
    call VUAssertEquals([{'word': '\NS1\Foo', 'kind': 'c', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': '\NS1\Foo - fixtures/CompleteGeneral/namespaced_foo.php'}], res)

    let res = phpcomplete#CompleteGeneral('\NS1\SUBNS\F', 'NS1', {})
    call VUAssertEquals([{'word': '\NS1\SUBNS\FooSub', 'kind': 'c', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': '\NS1\SUBNS\FooSub - fixtures/CompleteGeneral/namespaced_foo.php'}], res)

    " completes classnames from subnamespaces
    let res = phpcomplete#CompleteGeneral('SUBNS\F', 'NS1', {})
    call VUAssertEquals([{'word': 'SUBNS\FooSub', 'kind': 'c', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'SUBNS\FooSub - fixtures/CompleteGeneral/namespaced_foo.php'}], res)


    " stable ctags branch with no actual namespace information
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/old_style_namespaced_tags'

    " class names should be completed regardless of the namespaces,
    " simply matching the word after the last \ segment
    let res = phpcomplete#CompleteGeneral('\NS1\F', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'Foo', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'Foo - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'c'},
                \ {'word': 'FooSub', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'FooSub - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'c'},
                \ {'word': 'FooSubSub', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'FooSubSub - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'c'}],
                \ res)
endf " }}}

fun! TestCase_completes_top_level_functions_from_tags_in_matching_namespaces() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/namespaced_tags'

    " this is where function name part must have at least the configured amount
    " of letters to start matching
    let g:phpcomplete_min_num_of_chars_for_namespace_completion = 1

    let res = phpcomplete#CompleteGeneral('b', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'bar(', 'info': 'bar() - fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'}],
                \ res)

    " leaves leading slash in
    let res = phpcomplete#CompleteGeneral('\NS1\b', 'NS1', {})
    call VUAssertEquals([
                \ {'word': '\NS1\bar(', 'info': '\NS1\bar() - fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'}],
                \ res)

    " returns functions from subnamespace
    let res = phpcomplete#CompleteGeneral('SUBNS\b', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'SUBNS\barsub(', 'info': 'SUBNS\barsub() - fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'}],
                \ res)

    " stable ctags branch with no actual namespace information
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/old_style_namespaced_tags'

    " functions should be completed regardless of the namespaces,
    " simply matching the word after the last \ segment
    let res = phpcomplete#CompleteGeneral('\NS1\ba', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'bar(', 'info': 'bar() - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'},
                \ {'word': 'barsub(', 'info': 'barsub() - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'},
                \ {'word': 'barsubsub(', 'info': 'barsubsub() - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'menu': ') - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'f'}],
                \ res)
endf " }}}

fun! TestCase_completes_constants_from_tags_in_matching_namespaces() " {{{
    call SetUp()
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/namespaced_tags'

    let res = phpcomplete#CompleteGeneral('Z', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'ZAP', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'ZAP - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'd'}],
                \ res)

    " leaves leading slash in
    let res = phpcomplete#CompleteGeneral('\NS1\Z', 'NS1', {})
    call VUAssertEquals([
                \ {'word': '\NS1\ZAP', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': '\NS1\ZAP - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'd'}],
                \ res)

    " returns constants from subnamespace
    let res = phpcomplete#CompleteGeneral('SUBNS\Z', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'SUBNS\ZAPSUB', 'menu': ' - fixtures/CompleteGeneral/namespaced_foo.php', 'info': 'SUBNS\ZAPSUB - fixtures/CompleteGeneral/namespaced_foo.php', 'kind': 'd'}],
                \ res)

    " stable ctags branch with no actual namespace information
    exe ':set tags='.expand('%:p:h').'/'.'fixtures/CompleteGeneral/old_style_namespaced_tags'

    " constants should be completed regardless of the namespaces,
    " simply matching the word after the last \ segment
    " leaves leading slash in
    let res = phpcomplete#CompleteGeneral('\NS1\Z', 'NS1', {})
    call VUAssertEquals([
                \ {'word': 'ZAP', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'info': 'ZAP - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'kind': 'd'},
                \ {'word': 'ZAPSUB', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'info': 'ZAPSUB - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'kind': 'd'},
                \ {'word': 'ZAPSUBSUB', 'menu': ' - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'info': 'ZAPSUBSUB - fixtures/CompleteGeneral/fixtures/CompleteGeneral/namespaced_constants.php', 'kind': 'd'}],
                \ res)
endf " }}}

fun! TestCase_returns_completions_from_imported_names() " {{{
    call SetUp()

    let res = phpcomplete#CompleteGeneral('A', '', {'AO': {'name': 'ArrayObject', 'kind': 'c', 'builtin': 1,}})
    call VUAssertEquals([
                \ {'word': 'AO', 'menu': ' ArrayObject - builtin', 'info': 'AO ArrayObject - builtin', 'kind': 'c'}],
                \ res)

    let res = phpcomplete#CompleteGeneral('NS', '', {'NS1': {'name': 'NS1', 'kind': 'n', 'builtin': 0, 'filename': 'some_file.php'}})
    call VUAssertEquals([
                \ {'word': 'NS1\', 'menu': ' NS1 - some_file.php', 'info': ' NS1 - some_file.php', 'kind': 'n'}],
                \ res)
endf " }}}

fun! TestCase_returns_tags_from_imported_namespaces() " {{{
    call SetUp()

    exe ':set tags='.expand('%:p:h').'/'.'fixtures/common/namespaced_foo_tags'

    " class in imported namespace without renaming
    let res = phpcomplete#CompleteGeneral('SUBNS\F', '\', {'SUBNS': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUBNS\FooSub', 'menu': ' - fixtures/common/namespaced_foo.php', 'info': 'SUBNS\FooSub - fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " class in imported namespace when the import is renamed
    let res = phpcomplete#CompleteGeneral('SUB\F', '\', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUB\FooSub', 'menu': ' - fixtures/common/namespaced_foo.php', 'info': 'SUB\FooSub - fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " class in sub-namespace of the imported namespace when the import is renamed
    let res = phpcomplete#CompleteGeneral('SUB\SUBSUB\F', '\', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUB\SUBSUB\FooSubSub', 'menu': ' - fixtures/common/namespaced_foo.php', 'info': 'SUB\SUBSUB\FooSubSub - fixtures/common/namespaced_foo.php', 'kind': 'c'}],
                \ res)

    " imported namespace name
    let res = phpcomplete#CompleteGeneral('SUB', '\', {'SUBNS': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUBNS\', 'menu': ' NS1\SUBNS - fixtures/common/namespaced_foo.php', 'info': ' NS1\SUBNS - fixtures/common/namespaced_foo.php', 'kind': 'n'}],
                \ res)

    " imported and renamed namespace name
    let res = phpcomplete#CompleteGeneral('SU', '\', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUB\', 'menu': ' NS1\SUBNS - fixtures/common/namespaced_foo.php', 'info': ' NS1\SUBNS - fixtures/common/namespaced_foo.php', 'kind': 'n'}],
                \ res)

    " sub namespace of imported and renamed namespace name
    let res = phpcomplete#CompleteGeneral('SUB\SUB', '\', {'SUB': {'name': 'NS1\SUBNS', 'kind': 'n', 'builtin': 0, 'filename': 'fixtures/common/namespaced_foo.php'}})
    call VUAssertEquals([
                \ {'word': 'SUB\SUBSUB\', 'menu': 'NS1\SUBNS\SUBSUB - fixtures/common/namespaced_foo.php', 'info': 'NS1\SUBNS\SUBSUB - fixtures/common/namespaced_foo.php', 'kind': 'n'}],
                \ res)
endf " }}}

" vim: foldmethod=marker:expandtab:ts=4:sts=4
