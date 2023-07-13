[
  (arguments)
  (array)
  (binary_expression)
  (class_body)
  (export_clause)
  (formal_parameters)
  (named_imports)
  (object)
  (object_pattern)
  (parenthesized_expression)
  (return_statement)
  (statement_block)
  (switch_case)
  (switch_default)
  (switch_statement)
  (template_substitution)
  (ternary_expression)
] @indent.begin

(arguments (call_expression) @indent.begin)
(binary_expression (call_expression) @indent.begin)
(expression_statement (call_expression) @indent.begin)
(arrow_function
  body: (_) @_body
  (#not-has-type? @_body statement_block)
) @indent.begin
(assignment_expression
  right: (_) @_right
  (#not-has-type? @_right arrow_function function)
) @indent.begin
(variable_declarator
  value: (_) @_value
  (#not-has-type? @_value arrow_function call_expression function)
) @indent.begin

(arguments ")" @indent.end)
(object "}" @indent.end)
(statement_block "}" @indent.end)

[
  (arguments (object))
  ")"
  "}"
  "]"
] @indent.branch
(statement_block "{" @indent.branch)

(parenthesized_expression ("(" (_) ")" @indent.end))
["}" "]"] @indent.end

(template_string) @indent.ignore

[
  (comment)
  (ERROR)
] @indent.auto
