[
  (array)
  (object)
] @indent.begin

"}" @indent.end

[ "{" "}" ] @indent.branch

[ "[" "]" ] @indent.branch

[ "(" ")" ] @indent.branch

[
  (ERROR)
  (comment)
  (diagnostic_comment)
] @indent.auto
