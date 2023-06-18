(definition) @indent.begin

((parameters (parameter)) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))

"}" @indent.end

[ "{" "}" ] @indent.branch

[ "(" ")" ] @indent.branch

[
  (ERROR)
  (comment)
] @indent.auto
