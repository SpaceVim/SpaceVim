; References

(identifier) @reference

; Definitions

(function_definition
  name: (identifier) @definition.function
  (function_arguments
    (identifier)* @definition.parameter
    ("," (identifier) @definition.parameter)*)?) @scope

(assignment left: (identifier) @definition.var)
(multioutput_variable (identifier) @definition.var)

(iterator . (identifier) @definition.var)
(lambda (arguments (identifier) @definition.parameter))
(global_operator (identifier) @definition.var)
(persistent_operator (identifier) @definition.var)
(catch_clause (identifier) @definition)
