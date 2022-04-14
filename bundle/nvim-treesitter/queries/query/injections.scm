((predicate 
  name: (identifier) @_name
  parameters: (parameters (string) @regex))
 (#match? @_name "^#?(not-)?(match|vim-match|lua-match)$"))

(comment) @comment
