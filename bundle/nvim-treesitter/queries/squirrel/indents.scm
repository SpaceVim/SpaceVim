[
  (class_declaration)
  (function_declaration)
  (enum_declaration)

  (array)
  (block)
  (table)
  (anonymous_function)
  (parenthesized_expression)

  (while_statement)
  (switch_statement)
  (for_statement)
  (foreach_statement)
  ; (try_statement)
  (catch_statement)
] @indent.begin

(
  (if_statement)
  (ERROR "else") @indent.begin
)

(if_statement
  condition: (_) @indent.begin)

(if_statement
  consequence: (_)
  (else_statement) @indent.begin)

(do_while_statement
  "do"
  (_) @indent.begin)

(try_statement
  (_) @indent.begin
  (catch_statement) @indent.begin)

[ "{" "}" ] @indent.branch

[ "(" ")" ] @indent.branch

[ "[" "]" ] @indent.branch

[
  "}"
  ")"
  "]"
] @indent.end

[
  (ERROR)
  (comment)

  (string)
  (verbatim_string)
] @indent.auto
