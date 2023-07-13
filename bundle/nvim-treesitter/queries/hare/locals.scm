; Scopes

[
  (module)
  (function_declaration)
  (if_statement)
  (for_statement)
  (match_expression)
  (switch_expression)
] @scope

; References

[
  (identifier)
  (scoped_type_identifier)
] @reference

; Definitions

(global_binding
  (identifier) @definition.constant . ":" (_))

(const_declaration
  "const" (identifier) @definition.constant . "=")

(field
  . (identifier) @definition.field)

(field_assignment
  . (identifier) @definition.field)

(function_declaration
  "fn" . (identifier) @definition.function)

(parameter
  (_) @definition.parameter . ":")

(type_declaration
  "type" (identifier) @definition.type . "=")

(type_declaration
  "type" (identifier) @definition.enum . "=" (enum_type))

(let_declaration
  "let" . (identifier) @definition.variable ","?)

