; Identifiers

((identifier) @constant (#match? @constant "^[A-Z][A-Z\\d_]+$"))

(namespaced_identifier
  left: [
    ; Lowercased names in lhs typically are variables, while camel cased are namespaces
    ; ((identifier) @namespace (#match? @namespace "^[A-Z]+[a-z]+$"))
    ((identifier) @variable (#match? @variable "^[a-z]"))
    (_)
  ]
  right: [
    ; Lowercased are variables, camel cased are types
    ; ((identifier) @parameter (#match? @parameter "^[a-z]"))
    ((identifier) @type (#match? @type "^[A-Z]+[a-z]+$"))
    (_)
  ]
)

((identifier) @constructor (#match? @constructor "^[A-Z]*[a-z]+"))

; Pointers

(address_of_identifier "&" @symbol)
(pointer_type "*" @symbol)
(indirection_identifier "*" @symbol)

; Misc

(number) @number

[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

[
  ";"
  ":"
  "."
  ","
  "->"
] @punctuation.delimiter

; Reserved keywords

[
  "return" 
  "yield"
  "break"
] @keyword.return


(null) @constant.builtin

[
  "typeof"
  "is"
] @keyword.operator

[
  (modifier)
  "var"
  "class"
  "interface"
  (property_parameter)
  (this)
  "enum"
  "new"
  "in"
  "as"
  "try"
  "catch"
  "requires"
  "ensures"
  "owned"
  "throws"
  "delete"
  "#if"
  "#elif"
  (preproc_else)
  (preproc_endif)
] @keyword

"throw" @exception

[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @conditional

[
  "for"
  "foreach"
  "while"
  "do"
] @repeat

[
  (true)
  (false)
] @boolean

; Operators

(binary_expression
  [
    "*"
    "/"
    "+"
    "-"
    "%"
    "<"
    "<="
    ">"
    ">="
    "=="
    "!="
    "+="
    "-="
    "*="
    "/="
    "%="
    "&&"
    "||"
    "&"
    "|"
    "^"
    "~"
    "|="
    "&="
    "^="
    "??"
    "="
  ] @operator    
)

(unary_expression
  [
    "-"
    "!"
    "--"
    "++"
  ] @operator
)

; Declaration

(declaration
  type_name: (_) @type
)

; Methods

(function_definition
  type: (_) @type
  name: [
  	(identifier) @method
    (generic_identifier (_) @type) 
  ]
)

(function_call
  identifier: [
  	(identifier) @method
    (generic_identifier (_) @type) 
  ]
)

(member_function
  identifier: [
  	(identifier) @method
    (generic_identifier (_) @type)
  ]
)

; Types

(primitive_type) @type

(nullable_type
    (_) @type
    "?" @symbol
)

; Comments

(comment) @comment

; Namespace

(namespace
  "namespace" @include
  (_) @namespace
)

"global::" @namespace

(using 
  "using" @include
  (_) @namespace
)

; Classes

(class_declaration) @type

(class_constructor_definition
  name: [
    (_)
    (namespaced_identifier (_) @constructor .)
  ] @constructor
)

(class_destructor
  "~" @symbol
  (_) @constructor
)

; Interfaces

(interface_declaration) @type

; Strings and escape sequences

(string_literal) @string
(verbatim) @string
(escape_sequence) @string.escape

(string_template
  "@" @symbol
) @string

(string_template_variable) @variable

(string_template_expression) @variable

; New instance from Object

(new_instance
  "new" @keyword
)

; GObject construct

(gobject_construct 
  "construct" @keyword
)

; Try statement

(try_statement
  exception: (parameter_list (declaration_parameter
    (_) @exception
    (_) @variable
  ))
)

; Enum

(enum_declaration
    name: (identifier) @type
)

; Loop

(foreach_statement
  loop_item: (identifier) @variable
)

; Casting

(static_cast
  type: (_) @type
)

(dynamic_cast
  type: (_) @type
)

; Regex

(regex_literal) @string.regex

; Code attribute

(code_attribute
  name: (identifier) @attribute
  param: (_) @attribute
) @attribute
