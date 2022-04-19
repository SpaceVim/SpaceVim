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
] @indent

[
  "}"
  ")"
] @branch

((formal_parameters (identifier)) @aligned_indent
 (#set! "delimiter" "()"))

[
  ")"
  "}"
] @indent_end

[
  (comment)
] @ignore
