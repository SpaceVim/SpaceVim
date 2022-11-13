; Lower priority to prefer @parameter when identifier appears in parameter_declaration.
((identifier) @variable (#set! "priority" 95))

[
  "const"
  "default"
  "enum"
  "extern"
  "inline"
  "static"
  "struct"
  "typedef"
  "union"
  "volatile"
  "goto"
  "register"
] @keyword

"sizeof" @keyword.operator
"return" @keyword.return

[
  "while"
  "for"
  "do"
  "continue"
  "break"
] @repeat

[
 "if"
 "else"
 "case"
 "switch"
] @conditional

"#define" @constant.macro
[
  "#if"
  "#ifdef"
  "#ifndef"
  "#else"
  "#elif"
  "#endif"
  (preproc_directive)
] @preproc

"#include" @include

[ ";" ":" "," ] @punctuation.delimiter

"..." @punctuation.special

[ "(" ")" "[" "]" "{" "}"] @punctuation.bracket

[
  "="

  "-"
  "*"
  "/"
  "+"
  "%"

  "~"
  "|"
  "&"
  "^"
  "<<"
  ">>"

  "->"
  "."

  "<"
  "<="
  ">="
  ">"
  "=="
  "!="

  "!"
  "&&"
  "||"

  "-="
  "+="
  "*="
  "/="
  "%="
  "|="
  "&="
  "^="
  ">>="
  "<<="
  "--"
  "++"
] @operator

;; Make sure the comma operator is given a highlight group after the comma
;; punctuator so the operator is highlighted properly.
(comma_expression [ "," ] @operator)

[
 (true)
 (false)
] @boolean

(conditional_expression [ "?" ":" ] @conditional)

(string_literal) @string
(system_lib_string) @string
(escape_sequence) @string.escape

(null) @constant.builtin
(number_literal) @number
(char_literal) @character

[
 (preproc_arg)
 (preproc_defined)
]  @function.macro

(((field_expression
     (field_identifier) @property)) @_parent
 (#not-has-parent? @_parent template_method function_declarator call_expression))

(field_designator) @property
(((field_identifier) @property)
 (#has-ancestor? @property field_declaration)
 (#not-has-ancestor? @property function_declarator))

(statement_identifier) @label

[
 (type_identifier)
 (primitive_type)
 (sized_type_specifier)
 (type_descriptor)
] @type

(sizeof_expression value: (parenthesized_expression (identifier) @type))

((identifier) @constant
 (#lua-match? @constant "^[A-Z][A-Z0-9_]+$"))
(enumerator
  name: (identifier) @constant)
(case_statement
  value: (identifier) @constant)

((identifier) @constant.builtin
    (#any-of? @constant.builtin "stderr" "stdin" "stdout"))

;; Preproc def / undef
(preproc_def
  name: (_) @constant)
(preproc_call
  directive: (preproc_directive) @_u
  argument: (_) @constant
  (#eq? @_u "#undef"))

(call_expression
  function: (identifier) @function.call)
(call_expression
  function: (field_expression
    field: (field_identifier) @function.call))
(function_declarator
  declarator: (identifier) @function)
(preproc_function_def
  name: (identifier) @function.macro)

(comment) @comment @spell

;; Parameters
(parameter_declaration
  declarator: (identifier) @parameter)

(parameter_declaration
  declarator: (pointer_declarator) @parameter)

(preproc_params (identifier) @parameter)

[
  "__attribute__"
  "__cdecl"
  "__clrcall"
  "__stdcall"
  "__fastcall"
  "__thiscall"
  "__vectorcall"
  "_unaligned"
  "__unaligned"
  "__declspec"
  (attribute_declaration)
] @attribute

(ERROR) @error
