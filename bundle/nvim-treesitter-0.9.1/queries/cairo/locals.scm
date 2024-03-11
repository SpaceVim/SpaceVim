; References

(identifier) @reference
((type_identifier) @reference
  (#set! reference.kind "type"))
((field_identifier) @reference
  (#set! reference.kind "field"))

; Scopes

[
  (program)
  (block)
  (function_definition)
  (loop_expression)
  (if_expression)
  (match_expression)
  (match_arm)

  (struct_item)
  (enum_item)
  (impl_item)
] @scope

(use_declaration 
  argument: (scoped_identifier 
              name: (identifier) @definition.import))

(use_as_clause 
  alias: (identifier) @definition.import)

(use_list
    (identifier) @definition.import) ; use std::process::{Child, Command, Stdio};

; Functions

(function_definition
    (identifier) @definition.function)

(function_definition
  (identifier) @definition.method
  (parameter (self)))

; Function with parameters, defines parameters

(parameter
  [ (identifier) (self) ]  @definition.parameter)

; Types

(struct_item
  name: (type_identifier) @definition.type)

(constrained_type_parameter 
  left: (type_identifier) @definition.type) ; the P in  remove_file<P: AsRef<Path>>(path: P)

(enum_item
  name: (type_identifier) @definition.type)

; Module

(mod_item 
  name: (identifier) @definition.namespace)

; Variables

(assignment_expression
 left: (identifier) @definition.var)
