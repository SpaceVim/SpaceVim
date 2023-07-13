[
  (parameter_list)
  (compound_statement)
  (loop_statement)
  (struct_declaration)
] @indent.begin

(compound_statement "}" @indent.end)
(loop_statement "}" @indent.end)
(function_declaration ")" @indent.end)
(struct_declaration "}" @indent.end)

[
  "else"
  ")"
  "}"
] @indent.branch

[(line_comment) (block_comment)] @indent.auto
