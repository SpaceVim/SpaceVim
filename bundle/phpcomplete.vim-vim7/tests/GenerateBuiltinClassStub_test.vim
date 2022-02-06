fun! SetUp()
    " disable built-in classes
    let g:php_builtin_classnames = {}
    " disable built-in classes
    let g:php_builtin_classes = {}
    " disable built-in interfaces
    let g:php_builtin_interfacenames = {}
    " disable built-in interfaces
    let g:php_builtin_interfaces = {}
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

fun! TestCase_can_generates_empty_class() " {{{
    call SetUp()
    " load fixture with methods and functions in it

	let g:php_builtin_classnames['fictionalbuiltinclass'] = ''
	let g:php_builtin_classes['fictionalbuiltinclass'] = {
	\   'name': 'FictionalBuiltinClass',
	\   'constants': {
	\   },
	\   'properties': {
	\   },
	\   'static_properties': {
	\   },
	\   'methods': {
	\   },
	\   'static_methods': {
	\   },
	\}
    let res = phpcomplete#GenerateBuiltinClassStub('class', g:php_builtin_classes['fictionalbuiltinclass'])
    call VUAssertEquals({
				\ 'file': 'VIMPHP_BUILTINOBJECT',
				\ 'mtime': 0,
				\ 'namespace': '',
				\ 'class': 'FictionalBuiltinClass',
				\ 'imports': {},
				\ 'content': "class FictionalBuiltinClass {\n}",
				\}, res)
endf " }}}

fun! TestCase_can_generates_empty_interface() " {{{
    call SetUp()
    " load fixture with methods and functions in it

	let g:php_builtin_interfacenames['fictionalbuiltininterface'] = ''
	let g:php_builtin_interfaces['fictionalbuiltininterface'] = {
	\   'name': 'FictionalBuiltinInterface',
	\   'methods': {
	\   },
	\}
    let res = phpcomplete#GenerateBuiltinClassStub('interface', g:php_builtin_interfaces['fictionalbuiltininterface'])
    call VUAssertEquals({
				\ 'file': 'VIMPHP_BUILTINOBJECT',
				\ 'mtime': 0,
				\ 'namespace': '',
				\ 'interface': 'FictionalBuiltinInterface',
				\ 'imports': {},
				\ 'content': "interface FictionalBuiltinInterface {\n}",
				\}, res)
endf " }}}

fun! TestCase_can_generates_class_from_class_info() " {{{
    call SetUp()
    " load fixture with methods and functions in it

	let g:php_builtin_classnames['fictionalbuiltinclass'] = ''
	let g:php_builtin_classes['fictionalbuiltinclass'] = {
	\   'name': 'FictionalBuiltinClass',
	\   'constants': {
	\     'IS_PUBLIC': '256',
	\   },
	\   'properties': {
	\     'name': { 'initializer': '2', 'type': 'Foo'},
	\   },
	\   'static_properties': {
	\     '$_app': { 'initializer': '3', 'type': 'Foo2'},
	\   },
	\   'methods': {
	\     '__construct': { 'signature': 'string $name', 'return_type': 'Foo'},
	\     'getName': { 'signature': 'object $object | Closure', 'return_type': 'Closure'},
	\   },
	\   'static_methods': {
	\     'export': { 'signature': 'mixed $class, string $name [, bool $return] | string', 'return_type': 'string'},
	\   },
	\}

	let path = expand('%:p:h').'/'.'fixtures/GenerateBuiltinClassStub/fictionalbuiltinclass.txt'
	let good_answer = join(readfile(path), "\n")

    let res = phpcomplete#GenerateBuiltinClassStub('class', g:php_builtin_classes['fictionalbuiltinclass'])
    call VUAssertEquals({
				\ 'file': 'VIMPHP_BUILTINOBJECT',
				\ 'mtime': 0,
				\ 'namespace': '',
				\ 'class': 'FictionalBuiltinClass',
				\ 'imports': {},
				\ 'content': good_answer,
				\}, res)
endf " }}}

fun! TestCase_can_generates_class_from_class_info() " {{{
    call SetUp()
    " load fixture with methods and functions in it

	let g:php_builtin_interfacenames['arrayaccess'] = ''
	let g:php_builtin_interfaces['arrayaccess'] = {
	\   'name': 'ArrayAccess',
	\   'methods': {
	\     'offsetExists': { 'signature': 'mixed $offset | boolean', 'return_type': 'boolean'},
	\     'offsetGet': { 'signature': 'mixed $offset | mixed', 'return_type': 'mixed'},
	\     'offsetSet': { 'signature': 'mixed $offset, mixed $value | void', 'return_type': 'void'},
	\     'offsetUnset': { 'signature': 'mixed $offset | void', 'return_type': 'void'},
	\   },
	\}

	let path = expand('%:p:h').'/'.'fixtures/GenerateBuiltinClassStub/arrayaccess.txt'
	let good_answer = join(readfile(path), "\n")

    let res = phpcomplete#GenerateBuiltinClassStub('interface', g:php_builtin_interfaces['arrayaccess'])
    call VUAssertEquals({
				\ 'file': 'VIMPHP_BUILTINOBJECT',
				\ 'mtime': 0,
				\ 'namespace': '',
				\ 'interface': 'ArrayAccess',
				\ 'imports': {},
				\ 'content': good_answer,
				\}, res)
endf " }}}

" vim: foldmethod=marker:expandtab:ts=4:sts=4
