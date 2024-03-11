[
  (class_body)
  (function_body)
  (function_expression_body)
  (declaration (initializers))
  (switch_block)
  (if_statement)
  (formal_parameter_list)
  (formal_parameter)
  (list_literal)
  (return_statement)
  (arguments)
  (try_statement)
] @indent.begin

(switch_block
  (_) @indent.begin
  (#set! indent.immediate 1)
  (#set! indent.start_at_same_line 1))

[
  (switch_statement_case)
  (switch_statement_default)
] @indent.branch

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @indent.branch

[
 "}"
] @indent.end

(return_statement ";" @indent.end)
(break_statement ";" @indent.end)

; this one is for dedenting the else block
(if_statement (block) @indent.branch)

(comment) @indent.ignore
