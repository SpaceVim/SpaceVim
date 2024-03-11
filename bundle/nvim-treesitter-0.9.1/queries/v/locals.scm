((function_declaration
     name: (identifier) @definition.function)) ;@function

(var_declaration
  var_list: (expression_list
              (reference_expression
                (identifier) @definition.var)))

((function_declaration
  name: (identifier) @definition.function))

(const_declaration (const_definition name: (identifier) @definition.var))

(identifier) @reference

((call_expression name: (reference_expression (identifier)) @reference)
 (#set! reference.kind "call"))

((call_expression
   name: (selector_expression
                field: (reference_expression (identifier) @definition.function)))
 (#set! reference.kind "call"))

(source_file) @scope
(function_declaration) @scope
(if_expression) @scope
(block) @scope
(for_statement) @scope
