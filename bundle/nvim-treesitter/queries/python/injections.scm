((call
  function: (attribute
	  object: (identifier) @_re)
  arguments: (argument_list (string) @regex))
 (#eq? @_re "re")
 (#lua-match? @regex "^r.*"))

(comment) @comment
