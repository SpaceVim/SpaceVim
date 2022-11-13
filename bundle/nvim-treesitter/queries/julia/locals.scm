;;; Variables
(assignment_expression
  (identifier) @definition.var)
(assignment_expression
  (tuple_expression
    (identifier) @definition.var))

;;; let/const bindings
(variable_declaration
 (identifier) @definition.var)
(variable_declaration
 (tuple_expression
  (identifier) @definition.var))


;;; For bindings
(for_binding
  (identifier) @definition.var)
(for_binding
  (tuple_expression
    (identifier) @definition.var))


;;; Types

(struct_definition
  name: (identifier) @definition.type)
(abstract_definition
  name: (identifier) @definition.type)
(abstract_definition
  name: (identifier) @definition.type)

(type_parameter_list
  (identifier) @definition.type)

;;; Module imports

(import_statement
  (identifier) @definition.import)


;;; Parameters

(parameter_list
  (identifier) @definition.parameter)
(optional_parameter .
  (identifier) @definition.parameter)
(slurp_parameter
  (identifier) @definition.parameter)

(typed_parameter
  parameter: (identifier) @definition.parameter
  (_))

(function_expression
 . (identifier) @definition.parameter) ;; Single parameter arrow function


;;; Function/macro definitions

(function_definition
  name: (identifier) @definition.function) @scope
(short_function_definition
  name: (identifier) @definition.function) @scope
(macro_definition 
  name: (identifier) @definition.macro) @scope

(identifier) @reference

[
  (for_statement)
  (while_statement)
  (try_statement)
  (catch_clause)
  (finally_clause)
  (let_statement)
  (quote_statement)
  (do_clause)
] @scope
