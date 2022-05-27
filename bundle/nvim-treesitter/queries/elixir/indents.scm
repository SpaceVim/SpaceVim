[
  (block)
  (do_block)
  (list)
  (map)
  (stab_clause)
  (tuple)
  (arguments)
] @indent

[
  ")"
  "]"
  "after"
  "catch"
  "else"
  "rescue"
  "}"
  "end"
] @indent_end @branch

; Elixir pipelines are not indented, but other binary operator chains are
((binary_operator operator: _ @_operator) @indent (#not-eq? @_operator "|>"))
