; Scopes

[
  (block)
  (defined_resource_type)
  (parameter_list)
  (attribute_type_entry)
  (class_definition)
  (node_definition)
  (resource_declaration)
  (selector)
  (method_call)
  (case_statement)
  (hash)
  (array)
] @scope

; References

[
  (identifier)
  (class_identifier)
  (variable) 
] @reference

; Definitions

(attribute [(identifier) (variable)] @definition.field)

(function_declaration
  [(identifier) (class_identifier)] @definition.function)

(include_statement [(identifier) (class_identifier)] @definition.import)

(parameter (variable) @definition.parameter)

(class_definition
  [(identifier) (class_identifier)] @definition.type)

(node_definition
  (node_name (identifier) @definition.type))

(resource_declaration
  [(identifier) (class_identifier)] @definition.type)

(assignment . (variable) @definition.var)
