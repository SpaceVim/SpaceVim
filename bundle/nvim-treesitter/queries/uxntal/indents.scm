(memory_execution) @indent.auto

[
  (subroutine)
  (brackets)
] @indent.begin

"}" @indent.end

[ "{" "}" ] @indent.branch

[ "[" "]" ] @indent.branch

[
  (ERROR)
  (comment)
] @indent.auto
