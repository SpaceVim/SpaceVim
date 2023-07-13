;; Definitions

(function_signature
  name: (identifier) @definition.function)

(formal_parameter
  name: (identifier) @definition.parameter)

(initialized_variable_definition
  name: (identifier) @definition.var)

(initialized_identifier
  (identifier) @definition.var)

(static_final_declaration
  (identifier) @definition.var)

;; References

(identifier) @reference

;; Scopes

(class_definition
  body: (_) @scope)
[
 (block)
 (if_statement)
 (for_statement)
 (while_statement)
 (try_statement)
 (catch_clause)
 (finally_clause)
] @scope
