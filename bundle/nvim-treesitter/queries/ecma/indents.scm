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
  (switch_statement)
  (template_substitution)
  (ternary_expression)
] @indent

(arguments (call_expression) @indent)
(binary_expression (call_expression) @indent)
(expression_statement (call_expression) @indent)
(arrow_function
  body: (_) @_body
  (#not-has-type? @_body statement_block)
) @indent
(assignment_expression
  right: (_) @_right
  (#not-has-type? @_right arrow_function function)
) @indent
(variable_declarator
  value: (_) @_value
  (#not-has-type? @_value arrow_function call_expression function)
) @indent

(arguments ")" @indent_end)
(object "}" @indent_end)
(statement_block "}" @indent_end)

[
  (arguments (object))
  ")"
  "}"
  "]"
] @branch
(statement_block "{" @branch)

["}" "]"] @indent_end

[
  (comment)
  (template_string)
] @ignore

(ERROR) @auto
