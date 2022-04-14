; Keywords
[
  "as"
  "const"
  "external"
  "let"
  "opaque"
  "pub"
  "todo"
  "try"
] @keyword

; Function Keywords
[
  "fn"
  "type"
] @keyword.function

; Imports
[
  "import"
] @include

; Conditionals
[
  "case"
  "if"
] @conditional

; Exceptions
[
  "assert"
] @exception

; Punctuation
[
  "("
  ")"
  "<<"
  ">>"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  "."
] @punctuation.delimiter

[
  "#"
] @punctuation.special

; Operators
[
  "%"
  "&&"
  "*"
  "*."
  "+"
  "+."
  "-"
  "-."
  "->"
  ".."
  "/"
  "/."
  ":"
  "<"
  "<."
  "<="
  "<=."
  "="
  "=="
  ">"
  ">."
  ">="
  ">=."
  "|>"
  "||"
] @operator

; Identifiers
(identifier) @variable

; Comments
[
  (module_comment)
  (statement_comment) 
  (comment) 
] @comment

; Unused Identifiers
[
  (discard)
  (hole)
] @comment

; Modules & Imports
(module ("/" @namespace)?) @namespace
(import alias: ((identifier) @namespace)?)
(remote_type_identifier module: (identifier) @namespace)
(unqualified_import name: (identifier) @function)

; Strings
(string) @string

; Bit Strings
(bit_string_segment) @string.special

; Numbers
[
  (integer) 
  (float) 
  (bit_string_segment_option_unit)
] @number

; Function Parameter Labels
(function_call arguments: (arguments (argument label: (label) @symbol ":" @symbol)))
(function_parameter label: (label)? @symbol name: (identifier) @parameter (":" @parameter)?)

; Records
(record arguments: (arguments (argument label: (label) @property ":" @property)?))
(record_pattern_argument  label: (label) @property ":" @property)
(record_update_argument label: (label) @property ":" @property)
(field_access record: (identifier) @variable field: (label) @property)

; Type Constructors
(data_constructor_argument label: (label) @property ":" @property)

; Type Parameters
(type_parameter) @parameter

; Types
((type_identifier) @type (#not-any-of? @type "True" "False"))

; Booleans
((type_identifier) @boolean (#any-of? @boolean "True" "False"))

; Type Variables
(type_var) @type

; Tuples
(tuple_access index: (integer) @operator)

; Functions
(function name: (identifier) @function)
(public_function name: (identifier) @function)
(function_call function: (identifier) @function)
(function_call function: (field_access field: (label) @function))

; External Functions
(public_external_function name: (identifier) @function)
(external_function name: (identifier) @function)
(external_function_body (string) @namespace . (string) @function)

; Pipe Operator
(binary_expression operator: "|>" right: (identifier) @function)

; Parser Errors
(ERROR) @error
