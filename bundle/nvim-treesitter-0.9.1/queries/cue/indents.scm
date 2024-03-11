[
  (import_spec_list)
  (field)
] @indent.begin

[
  "}"
  "]"
  ")"
] @indent.end

[ "{" "}" ] @indent.branch

[ "[" "]" ] @indent.branch

[ "(" ")" ] @indent.branch

[
  (ERROR)
  (comment)
] @indent.auto
