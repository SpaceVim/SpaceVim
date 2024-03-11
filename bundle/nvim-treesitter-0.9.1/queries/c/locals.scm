;; Functions definitions
(function_declarator
  declarator: (identifier) @definition.function)
(preproc_function_def
  name: (identifier) @definition.macro) @scope

(preproc_def
  name: (identifier) @definition.macro)
(pointer_declarator
  declarator: (identifier) @definition.var)
(parameter_declaration
  declarator: (identifier) @definition.parameter)
(init_declarator
  declarator: (identifier) @definition.var)
(array_declarator
  declarator: (identifier) @definition.var)
(declaration
  declarator: (identifier) @definition.var)
(enum_specifier
  name: (_) @definition.type
  (enumerator_list
    (enumerator name: (identifier) @definition.var)))

;; Type / Struct / Enum
(field_declaration
  declarator: (field_identifier) @definition.field)
(type_definition
  declarator: (type_identifier) @definition.type)
(struct_specifier
  name: (type_identifier) @definition.type)

;; goto
(labeled_statement (statement_identifier) @definition)

;; References
(identifier) @reference
((field_identifier) @reference
                    (#set! reference.kind "field"))
((type_identifier) @reference
                   (#set! reference.kind "type"))

(goto_statement (statement_identifier) @reference)

;; Scope
[
 (for_statement)
 (if_statement)
 (while_statement)
 (translation_unit)
 (function_definition)
 (compound_statement) ; a block in curly braces
 (struct_specifier)
] @scope
