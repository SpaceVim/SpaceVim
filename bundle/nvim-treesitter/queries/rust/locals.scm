; Imports
(extern_crate_declaration
    name: (identifier) @definition.import)

(use_declaration 
  argument: (scoped_identifier 
              name: (identifier) @definition.import))  

(use_as_clause 
  alias: (identifier) @definition.import)

(use_list
    (identifier) @definition.import) ; use std::process::{Child, Command, Stdio};

; Functions
(function_item 
    name: (identifier) @definition.function)

(function_item 
  name: (identifier) @definition.method
  parameters: (parameters 
                (self_parameter)))

; Variables
(parameter 
  pattern: (identifier) @definition.var) 

(let_declaration 
  pattern: (identifier) @definition.var)

(const_item 
  name: (identifier) @definition.var)

(tuple_pattern
  (identifier) @definition.var) 

(let_condition
  pattern: (_
             (identifier) @definition.var))

(tuple_struct_pattern
  (identifier) @definition.var)

(closure_parameters
  (identifier) @definition.var)

(self_parameter
  (self) @definition.var)

(for_expression 
  pattern: (identifier) @definition.var)

; Types
(struct_item
  name: (type_identifier) @definition.type)

(constrained_type_parameter 
  left: (type_identifier) @definition.type) ; the P in  remove_file<P: AsRef<Path>>(path: P)

(enum_item
  name: (type_identifier) @definition.type)


; Fields
(field_declaration
  name: (field_identifier) @definition.field)

(enum_variant
  name: (identifier) @definition.field) 

; References
(identifier) @reference
((type_identifier) @reference
                   (set! reference.kind "type"))
((field_identifier) @reference
                   (set! reference.kind "field"))


; Macros
(macro_definition
  name: (identifier) @definition.macro)

; Module
(mod_item 
  name: (identifier) @definition.namespace)

; Scopes
[
 (block)
 (function_item)
 (closure_expression)
 (while_expression)
 (for_expression)
 (loop_expression)
 (if_expression)
 (match_expression)
 (match_arm)

 (struct_item)
 (enum_item)
 (impl_item)
] @scope

