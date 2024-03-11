[
  (list)
  (dictionary)
  (set)

  (for_statement)
  (if_statement)
  (while_statement)
  (with_statement)

  (parenthesized_expression)
  (dictionary_comprehension)
  (list_comprehension)
  (set_comprehension)

  (tuple_pattern)
  (list_pattern)
  (binary_operator)

  (lambda)
  (function_definition)
] @indent.begin

(if_statement
  condition: (parenthesized_expression) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")")
)
((ERROR "(" . (_)) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))
((argument_list) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))
((argument_list) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))
((parameters) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))
((tuple) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))

[
  ")"
  "]"
  "}"
  (elif_clause)
  (else_clause)
] @indent.branch

(string) @indent.auto
