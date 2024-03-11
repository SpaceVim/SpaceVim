[
  (brace_list)
  (paren_list)
  (special)
  (pipe)
  (call)
  "|>"
  "if"
  "else"
  "while"
  "repeat"
  "for"
] @indent.begin

((binary operator: (special)) @indent.begin)

[
  "}"
  ")"
] @indent.branch

((formal_parameters (identifier)) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))

[
  ")"
  "}"
] @indent.end

[
  (comment)
] @indent.ignore
