; Gleam indents similar to Rust and JavaScript
[
  (anonymous_function)
  (assert)
  (case)
  (case_clause)
  (constant)
  (external_function)
  (function)
  (import)
  (let)
  (list)
  (constant)
  (function)
  (type_definition)
  (type_alias)
  (todo)
  (tuple)
] @indent.begin

[
  ")"
  "]"
  "}"
] @indent.end @indent.branch

; Gleam pipelines are not indented, but other binary expression chains are
((binary_expression operator: _ @_operator) @indent.begin (#not-eq? @_operator "|>"))
