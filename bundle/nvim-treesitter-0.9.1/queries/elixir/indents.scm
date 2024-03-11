[
  (block)
  (do_block)
  (list)
  (map)
  (stab_clause)
  (tuple)
  (arguments)
] @indent.begin

[
  ")"
  "]"
  "after"
  "catch"
  "else"
  "rescue"
  "}"
  "end"
] @indent.end @indent.branch

; Elixir pipelines are not indented, but other binary operator chains are
((binary_operator operator: _ @_operator) @indent.begin (#not-eq? @_operator "|>"))
