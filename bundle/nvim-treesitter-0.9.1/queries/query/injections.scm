((predicate 
  name: (identifier) @_name
  parameters: (parameters (string) @regex))
 (#match? @_name "^#?(not-)?(match|vim-match)$")
 (#offset! @regex 0 1 0 -1))

((predicate
  name: (identifier) @_name
  parameters: (parameters (string) @luap))
 (#match? @_name "^#?(not-)?lua-match$")
 (#offset! @luap 0 1 0 -1))

(comment) @comment
