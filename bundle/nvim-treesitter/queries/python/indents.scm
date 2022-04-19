[
  (list)
  (dictionary)
  (set)

  (if_statement)
  (for_statement)
  (while_statement)
  (with_statement)
  (try_statement)
  (import_from_statement)

  (parenthesized_expression)
  (generator_expression)
  (list_comprehension)
  (set_comprehension)
  (dictionary_comprehension)

  (tuple_pattern)
  (list_pattern)
  (binary_operator)

  (lambda)
  (function_definition)
  (class_definition)

  (concatenated_string)
] @indent
  
(if_statement
  condition: (parenthesized_expression) @aligned_indent
  (#set! "delimiter" "()")
)
((ERROR "(" . (_)) @aligned_indent
 (#set! "delimiter" "()"))
((argument_list) @aligned_indent
 (#set! "delimiter" "()"))
((argument_list) @aligned_indent
 (#set! "delimiter" "()"))
((parameters) @aligned_indent
 (#set! "delimiter" "()"))
((tuple) @aligned_indent
 (#set! "delimiter" "()"))

[
  ")"
  "]"
  "}"
  (elif_clause)
  (else_clause)
  (except_clause)
  (finally_clause)
] @branch

(string) @auto
