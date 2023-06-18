; Subroutines & scoping
(block
  ")" @indent.branch .) @indent.begin


; Control flow statements
(
  (if_block
    condition: (_)
    . (_) @_then) @indent.begin
  (#not-has-type? @_then block)
)

(else_block) @indent.branch

(else_block
  (if_block) @indent.dedent) @indent.branch

(
  (else_block
    (if_block
      condition: (_)
      . (_) @_then)) @indent.branch
  (#not-has-type? @_then block)
)

(while_block
  (command_expression)) @indent.auto

(repeat_block
  (command_expression)) @indent.auto


(comment) @indent.auto
