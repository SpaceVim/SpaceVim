;; Scopes
[
  (command)
  (function_definition)
  (if_statement)
  (for_statement)
  (begin_statement)
  (while_statement)
  (switch_statement)
] @scope

;; Definitions
(function_definition
  name: (word) @definition.function)

;; References
(variable_name) @reference
(word) @reference
