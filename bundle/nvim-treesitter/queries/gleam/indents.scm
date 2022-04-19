; Gleam indents similar to Rust and JavaScript
[
  (assert)
  (case)
  (case_clause)
  (constant)
  (expression_group)
  (external_function)
  (function)
  (import)
  (let)
  (list)
  (public_constant)
  (public_external_function)
  (public_function)
  (public_opaque_type_definition)
  (public_type_alias)
  (public_type_definition)
  (todo)
  (try)
  (tuple)
  (type_alias)
  (type_definition)
] @indent

[
  ")"
  "]"
  "}"
] @indent_end @branch

; Gleam pipelines are not indented, but other binary expression chains are
((binary_expression operator: _ @_operator) @indent (#not-eq? @_operator "|>"))
