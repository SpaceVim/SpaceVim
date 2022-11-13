((function_declaration
     name: (identifier) @definition.function)) ;@function

(short_var_declaration
  left: (expression_list
          (identifier) @definition.var))

((function_declaration
  name: (binded_identifier
          name: (identifier) @definition.function)))

(const_declaration (const_spec (identifier) @definition.var))

(identifier) @reference
(type_identifier) @reference

((call_expression function: (identifier) @reference)
 (#set! reference.kind "call"))

((call_expression
   function: (selector_expression
                field: (identifier) @definition.function))
 (#set! reference.kind "call"))

(source_file) @scope
(function_declaration) @scope
(if_expression) @scope
(block) @scope
(for_statement) @scope
