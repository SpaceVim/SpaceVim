[(line_comment) (block_comment)] @comment

; Keywords
[
    "if"
    "then"
    "else"
    (case)
    (of)
] @conditional

[
  "let"
  "in"
  (as)
  (port)
  (exposing)
  (alias)
  (infix)
  (module)
] @keyword

[
  (double_dot)
  "|"
] @punctuation.special
[
  ","
  (dot)
] @punctuation.delimiter

[
  "("
  ")"
  "{"
  "}"
] @punctuation.bracket

(type_annotation(lower_case_identifier) @function)
(port_annotation(lower_case_identifier) @function)
(function_declaration_left(lower_case_identifier) @function)
(function_call_expr target:
  (value_expr) @function)

(value_qid (upper_case_identifier) @constructor)
(value_qid ((dot) (lower_case_identifier) @field))
(field_access_expr ((dot) (lower_case_identifier) @field))

(lower_pattern) @parameter
(record_base_identifier) @method

[
  (backslash)
  (underscore)
] @function

[
  (operator_identifier)
  (eq)
  (colon)
  (arrow)
] @operator

(import) @include

(number_constant_expr) @number

(type) @keyword

(module_declaration(upper_case_qid(upper_case_identifier)) @constructor)
(type_declaration(upper_case_identifier) @constructor)
(type_ref) @type
(type_alias_declaration name: (upper_case_identifier) @type)
(field_type name:
    (lower_case_identifier) @property)

(union_variant(upper_case_identifier) @symbol)
(union_pattern) @symbol
(value_expr(upper_case_qid(upper_case_identifier)) @symbol)

; strings
(string_escape) @string
(open_quote) @string
(close_quote) @string
(regular_string_part) @string

[
  (open_char)
  (close_char)
] @character
