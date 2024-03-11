[
  (array_creation_expression)
  (compound_statement)
  (declaration_list)
  (binary_expression)
  (return_statement)
  (arguments)
  (formal_parameters)
  (enum_declaration_list)
  (switch_block)
  (match_block)
  (case_statement)
  "["
] @indent.begin

[
  ")"
  "}"
  "]"
] @indent.branch

[
  (comment)
] @indent.auto

(compound_statement "}" @indent.end)

(ERROR) @indent.auto
