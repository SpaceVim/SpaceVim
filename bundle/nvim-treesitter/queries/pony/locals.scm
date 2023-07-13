; Scopes

[
  (use_statement) 
  (actor_definition)
  (class_definition)
  (primitive_definition)
  (interface_definition)
  (trait_definition)
  (struct_definition)

  (constructor)
  (method)
  (behavior)

  (if_statement)
  (iftype_statement)
  (elseif_block)
  (elseiftype_block)
  (else_block)
  (for_statement)
  (while_statement)
  (try_statement)
  (with_statement)
  (repeat_statement)
  (recover_statement)
  (match_statement)
  (case_statement)
  (parenthesized_expression)
  (tuple_expression)

  (array_literal)
  (object_literal) 
] @scope

; References

(identifier) @reference

; Definitions

(field
  name: (identifier) @definition.field)

(use_statement
  (identifier) @definition.import)

(constructor
  (identifier) @definition.method)

(method
  (identifier) @definition.method)

(behavior
  (identifier) @definition.method)

(actor_definition
  (identifier) @definition.type)

(type_alias
  (identifier) @definition.type)

(class_definition
  (identifier) @definition.type)

(primitive_definition
  (identifier) @definition.type)

(interface_definition
  (identifier) @definition.type)

(trait_definition
  (identifier) @definition.type)

(struct_definition
  (identifier) @definition.type)

(parameter
  name: (identifier) @definition.parameter)

(variable_declaration
  (identifier) @definition.var)

(for_statement
  [
    (identifier) @definition.var
    (tuple_expression (identifier) @definition.var)
  ])

(with_elem 
  (identifier) @definition.var)
