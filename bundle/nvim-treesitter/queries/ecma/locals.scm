; Scopes
;-------

(statement_block) @scope
(function) @scope
(arrow_function) @scope
(function_declaration) @scope
(method_definition) @scope
(for_statement) @scope
(for_in_statement) @scope
(catch_clause) @scope

; Definitions
;------------

(variable_declarator
  name: (identifier) @definition.var)

(import_specifier
  (identifier) @definition.import)

(namespace_import
  (identifier) @definition.import)

(function_declaration
  ((identifier) @definition.function)
   (#set! definition.var.scope parent))

(method_definition
  ((property_identifier) @definition.function)
   (#set! definition.var.scope parent))

; References
;------------

(identifier) @reference
(shorthand_property_identifier) @reference
