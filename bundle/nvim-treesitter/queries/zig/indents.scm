[
  (Block)
  (ContainerDecl)
  (SwitchExpr)
  (InitList)
] @indent.begin

(Block "}" @indent.end)

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @indent.branch

[
  (line_comment)
  (container_doc_comment)
  (doc_comment)
  (LINESTRING)
] @indent.ignore
