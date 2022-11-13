; Scopes
[
  (bounded_quantification)
  (function_definition) 
  (lambda) 
  (module) 
  (module_definition) 
  (pcal_algorithm)
  (pcal_macro)
  (pcal_procedure)
  (pcal_with)
  (unbounded_quantification)
] @scope

; Definitions
(constant_declaration (identifier) @definition.constant)
(function_definition name: (identifier) @definition.function)
(lambda (identifier) @definition.parameter)
(operator_definition name: (identifier) @definition.function)
(operator_definition parameter: (identifier) @definition.parameter)
(pcal_macro_decl parameter: (identifier) @definition.parameter)
(pcal_proc_var_decl (identifier) @definition.parameter)
(pcal_var_decl (identifier) @definition.var)
(pcal_with (identifier) @definition.parameter)
(quantifier_bound (identifier) @definition.parameter)
(quantifier_bound (tuple_of_identifiers (identifier) @definition.parameter))
(variable_declaration (identifier) @definition.var)

; Builtin variables
(pcal_algorithm_body
  [
    (_ (identifier_ref) @definition.var)
    (_ (_ (identifier_ref) @definition.var))
    (_ (_ (_ (identifier_ref) @definition.var))) 
    (_ (_ (_ (_ (identifier_ref) @definition.var))))
    (_ (_ (_ (_ (_ (identifier_ref) @definition.var)))))
  ]
  (#vim-match? @definition.var "^(self|pc|stack)$")
)

; References
(identifier_ref) @reference
