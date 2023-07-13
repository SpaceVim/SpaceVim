[
  (element_node (element_node_start))
  (element_node_void)
  (block_statement (block_statement_start))
  (mustache_statement)
] @indent.begin

(element_node (element_node_end  [">"] @indent.end))
(element_node_void "/>" @indent.end)
[
 ">"
 "/>"
 "</"
 "{{/"
 "}}"
] @indent.branch

(mustache_statement
  (helper_invocation helper: (identifier) @_identifier (#eq? @_identifier "else"))
  ) @indent.branch
(mustache_statement ((identifier) @_identifier (#eq? @_identifier "else"))) @indent.branch
(comment_statement) @indent.ignore
