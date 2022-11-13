;;; Identifiers

(identifier) @variable

; ;; If you want type highlighting based on Julia naming conventions (this might collide with mathematical notation)
; ((identifier) @type
;   (match? @type "^[A-Z][^_]"))  ; exception: Highlight `A_foo` sort of identifiers as variables

(macro_identifier) @function.macro
(macro_identifier
  (identifier) @function.macro) ; for any one using the variable highlight

(macro_definition
  name: (identifier) @function.macro)

(quote_expression ":" (identifier)) @symbol


;;; Fields and indexes

(field_expression
  (identifier) @field .)

(index_expression
  (_)
  (range_expression
    (identifier) @constant.builtin .)
  (#eq? @constant.builtin "end"))


;;; Function names

;; definitions

(function_definition
  name: (identifier) @function)
(short_function_definition
  name: (identifier) @function)

(function_definition
  name: (scoped_identifier (identifier) @function .))
(short_function_definition
  name: (scoped_identifier (identifier) @function .))

;; calls

(call_expression
  (identifier) @function.call)
(call_expression
  (field_expression (identifier) @function.call .))

(broadcast_call_expression
  (identifier) @function.call)
(broadcast_call_expression
  (field_expression (identifier) @function.call .))


;;; Parameters

(parameter_list
  (identifier) @parameter)
(optional_parameter .
  (identifier) @parameter)
(slurp_parameter
  (identifier) @parameter)

(typed_parameter
  parameter: (identifier) @parameter
  type: (_) @type)
(typed_parameter
  type: (_) @type)

(function_expression
  . (identifier) @parameter) ; Single parameter arrow functions


;;; Types

;; Definitions

(abstract_definition
  name: (identifier) @type)
(primitive_definition
  name: (identifier) @type)
(struct_definition
  name: (identifier) @type)

;; Annotations

(parametrized_type_expression (_) @type)

(type_parameter_list
  (identifier) @type)

(typed_expression
  (identifier) @type .)

(function_definition
  return_type: (identifier) @type)
(short_function_definition
  return_type: (identifier) @type)

(where_clause
  (identifier) @type) ; where clause without braces


;;; Keywords

[
  "abstract"
  "const"
  "macro"
  "primitive"
  "struct"
  "type"
  "mutable"
  "where"
] @keyword

"end" @keyword

((identifier) @keyword (#any-of? @keyword "global" "local")) ; Grammar error

(compound_statement
  ["begin" "end"] @keyword)
(quote_statement
  ["quote" "end"] @keyword)
(let_statement
  ["let" "end"] @keyword)

(if_statement
  ["if" "end"] @conditional)
(elseif_clause
  ["elseif"] @conditional)
(else_clause
  ["else"] @conditional)
(ternary_expression
  ["?" ":"] @conditional)

(try_statement
  ["try" "end"] @exception)
(finally_clause
  "finally" @exception)
(catch_clause
  "catch" @exception)

(for_statement
  ["for" "end"] @repeat)
(while_statement
  ["while" "end"] @repeat)
(for_clause
  "for" @repeat)
[
  (break_statement)
  (continue_statement)
] @repeat

(module_definition
  ["module" "baremodule" "end"] @include)
(import_statement
  ["import" "using"] @include)
(export_statement
  "export" @include)

(macro_definition
  ["macro" "end" @keyword])

(function_definition
  ["function" "end"] @keyword.function)
(do_clause
  ["do" "end"] @keyword.function)
(function_expression
  "->" @keyword.function)
(return_statement
  "return" @keyword.return)


;;; Operators & Punctuation

(operator) @operator
(for_binding ["in" "=" "∈"] @operator)
(pair_expression "=>" @operator)
(range_expression ":" @operator)

(slurp_parameter "..." @operator)
(spread_expression "..." @operator)

"." @operator
["::" "<:"] @operator

["," ";"] @punctuation.delimiter
["(" ")" "[" "]" "{" "}"] @punctuation.bracket


;;; Literals

[
  (true)
  (false)
] @boolean

(integer_literal) @number
(float_literal) @float

((identifier) @float
  (#any-of? @float "NaN" "NaN16" "NaN32"
                   "Inf" "Inf16" "Inf32"))

((identifier) @constant.builtin
  (#any-of? @constant.builtin "nothing" "missing"))

(character_literal) @character
(escape_sequence) @string.escape

(string_literal) @string
(prefixed_string_literal
  prefix: (identifier) @function.macro) @string

(command_literal) @string.special
(prefixed_command_literal
  prefix: (identifier) @function.macro) @string.special

[
  (line_comment)
  (block_comment)
] @comment

