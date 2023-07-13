; Scopes

[
  (chunk)
  (do_statement)
  (while_statement)
  (repeat_statement)
  (if_statement)
  (for_statement)
  (function_declaration)
  (function_definition)
] @scope

; Definitions

(assignment_statement
  (variable_list
    (identifier) @definition.var))

(assignment_statement
  (variable_list
    (dot_index_expression . (_) @definition.associated (identifier) @definition.var)))

((function_declaration
  name: (identifier) @definition.function)
  (#set! definition.function.scope "parent"))

((function_declaration
  name: (dot_index_expression
    . (_) @definition.associated (identifier) @definition.function))
  (#set! definition.method.scope "parent"))

((function_declaration
  name: (method_index_expression
    . (_) @definition.associated (identifier) @definition.method))
  (#set! definition.method.scope "parent"))

(for_generic_clause
  (variable_list
    (identifier) @definition.var))

(for_numeric_clause
  name: (identifier) @definition.var)

(parameters (identifier) @definition.parameter)

; References

[
  (identifier)
] @reference
