[
  (Block)
  (ContainerDecl)
  (SwitchExpr)
  (InitList)
] @indent

(Block "}" @indent_end)

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @branch

[
  (line_comment)
  (container_doc_comment)
  (doc_comment)
  (LINESTRING)
] @ignore
