[
  (parameter_list)
  (compound_statement)
  (loop_statement)
  (struct_declaration)
] @indent

(compound_statement "}" @indent_end)
(loop_statement "}" @indent_end)
(function_declaration ")" @indent_end)
(struct_declaration "}" @indent_end)

[
  "else"
  ")"
  "}"
] @branch

(comment) @auto
