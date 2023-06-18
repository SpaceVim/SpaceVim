[
  (ast_block)
  (array)
  (expr)
  (json_array)
  (json_object)
  (parenthesized_expression)
] @indent.begin

; TODO: can't get this to work, goal is to indent at the property ":" prefix
; ((list (identifier) (property)) @indent.align
;   (#set! indent.open_delimiter "(")
;   (#set! indent.close_delimiter ")"))

[")" "}" "]"] @indent.end

[ "{" "}" ] @indent.branch

[ "(" ")" ] @indent.branch

[ "[" "]" ] @indent.branch

[
 (ERROR)
 (comment)
] @indent.auto
