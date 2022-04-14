; Scopes
;-------

((class_declaration
  name: (name) @definition.type) @scope
    (set! definition.type.scope "parent"))

((method_declaration
  name: (name) @definition.method) @scope
    (set! definition.method.scope "parent"))

((function_definition
  name: (name) @definition.function) @scope
    (set! definition.function.scope "parent"))

(anonymous_function_creation_expression
  (anonymous_function_use_clause
    (variable_name
      (name) @definition.var))) @scope

; Definitions
;------------

(simple_parameter
  (variable_name
    (name) @definition.var))

(foreach_statement
  (pair
    (variable_name
      (name) @definition.var)))

(foreach_statement
  (variable_name
    (name) @reference
      (set! reference.kind "var"))
  (variable_name
    (name) @definition.var))

(property_declaration
  (property_element
    (variable_name
      (name) @definition.field)))

(namespace_use_clause
  (qualified_name
    (name) @definition.type))

; References
;------------

(named_type
  (name) @reference
    (set! reference.kind "type"))

(named_type
  (qualified_name) @reference
    (set! reference.kind "type"))

(variable_name
  (name) @reference
    (set! reference.kind "var"))

(member_access_expression
  name: (name) @reference
    (set! reference.kind "field"))

(member_call_expression
  name: (name) @reference
    (set! reference.kind "method"))

(function_call_expression
  function: (qualified_name
    (name) @reference
      (set! reference.kind "function")))

(object_creation_expression
  (qualified_name
    (name) @reference
      (set! reference.kind "type")))

(scoped_call_expression
  scope: (qualified_name
    (name) @reference
      (set! reference.kind "type"))
  name: (name) @reference
    (set! reference.kind "method"))
