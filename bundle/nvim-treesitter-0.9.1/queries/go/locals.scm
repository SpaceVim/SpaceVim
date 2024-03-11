(
    (function_declaration
        name: (identifier) @definition.function) ;@function 
)

(
    (method_declaration
        name: (field_identifier) @definition.method); @method
)

(short_var_declaration 
  left: (expression_list
          (identifier) @definition.var)) 

(var_spec 
  name: (identifier) @definition.var)

(parameter_declaration (identifier) @definition.var)
(variadic_parameter_declaration (identifier) @definition.var)

(for_statement
 (range_clause
   left: (expression_list
           (identifier) @definition.var)))

(const_declaration
 (const_spec
  name: (identifier) @definition.var))

(type_declaration 
  (type_spec
    name: (type_identifier) @definition.type))

;; reference
(identifier) @reference
(type_identifier) @reference
(field_identifier) @reference
((package_identifier) @reference
  (#set! reference.kind "namespace"))

(package_clause
   (package_identifier) @definition.namespace)

(import_spec_list
  (import_spec
    name: (package_identifier) @definition.namespace))

;; Call references
((call_expression
   function: (identifier) @reference)
 (#set! reference.kind "call" ))

((call_expression
    function: (selector_expression
                field: (field_identifier) @reference))
 (#set! reference.kind "call" ))


((call_expression
    function: (parenthesized_expression
                (identifier) @reference))
 (#set! reference.kind "call" ))

((call_expression
   function: (parenthesized_expression
               (selector_expression
                 field: (field_identifier) @reference)))
 (#set! reference.kind "call" ))

;; Scopes

(func_literal) @scope
(source_file) @scope
(function_declaration) @scope
(if_statement) @scope
(block) @scope
(expression_switch_statement) @scope
(for_statement) @scope
(method_declaration) @scope
