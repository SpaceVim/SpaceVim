; Scopes
(function_definition) @scope

; Definitions
(variable_assignment 
  name: (variable_name) @definition.var)

(function_definition
  name: (word) @definition.function)

; References
(variable_name) @reference
(word) @reference
