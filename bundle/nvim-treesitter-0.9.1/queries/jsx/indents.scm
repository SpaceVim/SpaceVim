[
  (jsx_element)
  (jsx_self_closing_element)
  (jsx_expression)
] @indent.begin

(jsx_closing_element (">" @indent.end))
(jsx_self_closing_element "/>" @indent.end)

[
  (jsx_closing_element)
  ">"
] @indent.branch
; <button
; />
(jsx_self_closing_element "/>" @indent.branch)
