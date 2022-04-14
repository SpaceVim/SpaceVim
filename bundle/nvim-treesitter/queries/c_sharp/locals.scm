;; Definitions
(variable_declarator
  . (identifier) @definition.var)

(variable_declarator
  (tuple_pattern
    (identifier) @definition.var))

(declaration_expression
  name: (identifier) @definition.var)

(for_each_statement
  left: (identifier) @definition.var)

(for_each_statement
  left: (tuple_pattern
    (identifier) @definition.var))

(parameter
  (identifier) @definition.parameter)

(method_declaration
  name: (identifier) @definition.method)

(local_function_statement
  name: (identifier) @definition.method)

(property_declaration
  name: (identifier) @definition)

(type_parameter
  (identifier) @definition.type)

(class_declaration
  name: (identifier) @definition)

;; References
(identifier) @reference

;; Scope
(block) @scope
