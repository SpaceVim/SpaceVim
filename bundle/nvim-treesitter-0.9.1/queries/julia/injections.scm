;; Inject markdown in docstrings 
((string_literal) @markdown
  . [
    (module_definition)
    (abstract_definition)
    (struct_definition)
    (function_definition)
    (short_function_definition)
    (assignment)
    (const_statement)
  ]
 (#lua-match? @markdown "^\"\"\"")
 (#offset! @markdown 0 3 0 -3))

[
  (line_comment)
  (block_comment)
] @comment

((prefixed_string_literal
   prefix: (identifier) @_prefix) @regex
 (#eq? @_prefix "r")
 (#offset! @regex 0 2 0 -1))
