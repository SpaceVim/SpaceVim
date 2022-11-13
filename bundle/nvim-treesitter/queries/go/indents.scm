[
  (import_declaration)
  (const_declaration)
  (var_declaration)
  (type_declaration)
  (composite_literal)
  (func_literal)
  (literal_value)
  (expression_case)
  (default_case)
  (block)
  (call_expression)
  (parameter_list)
] @indent

[
  "case"
  "}"
] @branch

(parameter_list ")" @branch)

(comment) @ignore
