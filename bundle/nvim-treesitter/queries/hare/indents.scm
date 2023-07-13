[
  (enum_type)
  (struct_type)
  (tuple_type)
  (union_type)

  (block)
  (for_statement)
  (call_expression)
  (case)

  (array_literal)
  (struct_literal)
  (tuple_literal)
] @indent.begin

(if_statement
   ("(" condition: (_) ")") @indent.begin)

[
  "}"
  "]"
  ")"
] @indent.end

[ "{" "}" ] @indent.branch

[ "[" "]" ] @indent.branch

[ "(" ")" ] @indent.branch

[
  (ERROR)
  (comment)
  (concatenated_string)
] @indent.auto
