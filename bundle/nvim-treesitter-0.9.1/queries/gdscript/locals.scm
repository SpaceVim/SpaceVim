;; Scopes

[
  (if_statement)
  (elif_clause)
  (else_clause)
  (for_statement)
  (while_statement)
  (function_definition)
  (constructor_definition)
  (class_definition)
  (match_statement)
  (pattern_section)
  (lambda)
  (get_body)
  (set_body)
] @scope

;; Parameters

(parameters (identifier) @definition.parameter)
(default_parameter (identifier) @definition.parameter)
(typed_parameter (identifier) @definition.parameter)
(typed_default_parameter (identifier) @definition.parameter)

;; Signals

; Can gdscript 2 signals be considered fields?
(signal_statement (name) @definition.field)

;; Variable Definitions

(const_statement (name) @definition.constant)
; onready and export variations are only properties.
(variable_statement (name) @definition.var)

(setter) @reference
(getter) @reference

;; Function Definition

((function_definition (name) @definition.function)
 (#set! "definition.function.scope" "parent"))

;; Lambda

; lambda names are not accessible and are only for debugging.
(lambda (name) @definition.function)

;; Source

(class_name_statement (name) @definition.type)

(source (variable_statement (name) @definition.field))
(source (onready_variable_statement (name) @definition.field))
(source (export_variable_statement (name) @definition.field))

;; Class

((class_definition (name) @definition.type)
 (#set! "definition.type.scope" "parent"))

(class_definition
  (body (variable_statement (name) @definition.field)))
(class_definition
  (body (onready_variable_statement (name) @definition.field)))
(class_definition
  (body (export_variable_statement (name) @definition.field)))
(class_definition
  (body (signal_statement (name) @definition.field)))

; Although a script is also a class, let's only define functions in an inner class as
; methods.
((class_definition
  (body (function_definition (name) @definition.method)))
 (#set! "definition.method.scope" "parent"))

;; Enum

((enum_definition (name) @definition.enum))

;; Repeat

(for_statement . (identifier) @definition.var)

;; Match Statement

(pattern_binding (identifier) @definition.var)

;; References

(identifier) @reference
