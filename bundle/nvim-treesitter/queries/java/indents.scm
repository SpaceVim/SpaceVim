[
  (class_body)
  (enum_body)
  (interface_body)
  (constructor_declaration)
  (constructor_body)
  (block)
  (switch_block)
  (array_initializer)
  (argument_list)
  (formal_parameters)
] @indent

(expression_statement (method_invocation) @indent)

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @branch

[
  "}"
] @indent_end

(line_comment) @ignore

[
  (ERROR)
  (block_comment)
] @auto
