[
  (block_statement)
  (case_statement)
  (token_string)
] @indent.begin

[
  "(" ")"
  "{" "}"
  "[" "]"
] @indent.branch

[
  (line_comment)
  (block_comment)
  (nesting_block_comment)
] @indent.ignore
