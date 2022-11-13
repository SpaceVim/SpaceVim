[
  (import_declaration)
  (const_declaration)
  (var_declaration)
  (type_declaration)
  (func_literal)
  (literal_value)
  (expression_case)
  (default_case)
  (block)
  (call_expression)
  (parameter_list)
  (struct_type)
] @indent

[
  "}"
] @branch

(const_declaration ")" @branch)
(import_spec_list ")" @branch)
(var_declaration ")" @branch)

[
 "}"
 ")"
] @indent_end

(parameter_list ")" @branch)

(comment) @ignore
