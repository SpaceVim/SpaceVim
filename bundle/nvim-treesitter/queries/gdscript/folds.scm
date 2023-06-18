[
  ; Body fold will "join" the next adjacent fold into a SUPER fold.
  ; This is an issue with the grammar.
  ; (body)

  (if_statement)
  (elif_clause)
  (else_clause)
  (for_statement)
  (while_statement)
  (class_definition)
  (enum_definition)
  (match_statement)
  (pattern_section)
  (function_definition)
  (lambda)
  (constructor_definition)
] @fold

; It's nice to be able to fold the if/elif/else clauses and the entire
; if_statement.
(if_statement (body) @fold)

; Fold strings that are probably doc strings.
(expression_statement (string) @fold)
