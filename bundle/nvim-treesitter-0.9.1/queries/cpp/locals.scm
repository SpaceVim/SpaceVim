; inherits: c

;; Parameters
(variadic_parameter_declaration
  declarator: (variadic_declarator
                (identifier) @definition.parameter))
(optional_parameter_declaration
  declarator: (identifier) @definition.parameter)
;; Class / struct definitions
(class_specifier) @scope

(reference_declarator
  (identifier) @definition.var)

(variadic_declarator
  (identifier) @definition.var)

(struct_specifier
  name: (qualified_identifier
          name: (type_identifier) @definition.type))

(class_specifier
  name: (type_identifier) @definition.type)

(concept_definition
  name: (identifier) @definition.type)

(class_specifier
  name: (qualified_identifier
          name: (type_identifier) @definition.type))

(alias_declaration
  name: (type_identifier) @definition.type)

;template <typename T>
(type_parameter_declaration
  (type_identifier) @definition.type)
(template_declaration) @scope

;; Namespaces
(namespace_definition
  name: (namespace_identifier) @definition.namespace
  body: (_) @scope)

(namespace_definition
  name: (nested_namespace_specifier) @definition.namespace
  body: (_) @scope)

((namespace_identifier) @reference
                        (#set! reference.kind "namespace"))

;; Function definitions
(template_function
  name: (identifier) @definition.function) @scope

(template_method
  name: (field_identifier) @definition.method) @scope

(function_declarator
  declarator: (qualified_identifier
                name: (identifier) @definition.function)) @scope

(field_declaration
  declarator: (function_declarator
                (field_identifier) @definition.method))

(lambda_expression) @scope

;; Control structures
(try_statement
  body: (_) @scope)

(catch_clause) @scope

(requires_expression) @scope
