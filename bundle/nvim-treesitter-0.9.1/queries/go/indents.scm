[
  (import_declaration)
  (const_declaration)
  (var_declaration)
  (type_declaration)
  (func_literal)
  (literal_value)
  (expression_case)
  (communication_case)
  (type_case)
  (default_case)
  (block)
  (call_expression)
  (parameter_list)
  (struct_type)
] @indent.begin

[
  "}"
] @indent.branch

(const_declaration ")" @indent.branch)
(import_spec_list ")" @indent.branch)
(var_declaration ")" @indent.branch)

[
 "}"
 ")"
] @indent.end

(parameter_list ")" @indent.branch)

(comment) @indent.ignore
