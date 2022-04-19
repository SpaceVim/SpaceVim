[
  (block_statement)
  (case_statement)
  (token_string)
] @indent

[
  "(" ")"
  "{" "}"
  "[" "]"
] @branch

[
  (line_comment)
  (block_comment)
  (nesting_block_comment)
] @ignore
