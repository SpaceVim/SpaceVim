[
  (function_definition)
  (statement_block)
  (if_statement)
  (while_statement)
  (for_statement)
  (foreach_statement)
  (catch_clause)
] @scope

(init_declarator
  name: (identifier) @definition.var)

(array_declarator
  name: (identifier) @definition.var)

(function_definition
  name: (identifier) @definition.function)

(parameter
  name: (identifier) @definition.parameter)

(tuple_capture
  (identifier) @definition.var)

(catch_clause
  parameter: (identifier) @definition.var)

(assignment_expression
  left: (identifier) @definition.var)

(call_expression
  function: (identifier) @reference)

(identifier) @reference
