; Scopes
;-------

[
  (compilation_unit)
  (structure)
  (signature)
  (module_binding)
  (functor)
  (let_binding)
  (match_case)
  (class_binding)
  (class_function)
  (method_definition)
  (let_expression)
  (fun_expression)
  (for_expression)
  (let_class_expression)
  (object_expression)
  (attribute_payload)
] @scope

; Definitions
;------------

(value_pattern) @definition.var

(let_binding
  pattern: (value_name) @definition.var
  (set! definition.var.scope "parent"))

(let_binding
  pattern: (tuple_pattern (value_name) @definition.var)
  (set! definition.var.scope "parent"))

(let_binding
  pattern: (record_pattern (field_pattern (value_name) @definition.var))
  (set! definition.var.scope "parent"))

(external (value_name) @definition.var)

(type_binding (type_constructor) @definition.type)

(abstract_type (type_constructor) @definition.type)

(method_definition (method_name) @definition.method)

(module_binding
  (module_name) @definition.namespace
  (set! definition.namespace.scope "parent"))

(module_parameter (module_name) @definition.namespace)

(module_type_definition (module_type_name) @definition.type)

; References
;------------

(value_path .
  (value_name) @reference
  (set! reference.kind "var"))

(type_constructor_path .
  (type_constructor) @reference
  (set! reference.kind "type"))

(method_invocation
  (method_name) @reference
  (set! reference.kind "method"))

(module_path .
  (module_name) @reference
  (set! reference.kind "type"))

(module_type_path .
  (module_type_name) @reference
  (set! reference.kind "type"))
