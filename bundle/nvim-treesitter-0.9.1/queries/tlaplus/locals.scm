; TLA+ scopes and definitions
[
  (bounded_quantification)
  (choose)
  (function_definition) 
  (function_literal)
  (lambda) 
  (let_in)
  (module) 
  (module_definition)
  (operator_definition)
  (set_filter)
  (set_map)
  (unbounded_quantification)
] @scope

(choose (identifier) @definition.parameter)
(choose (tuple_of_identifiers (identifier) @definition.parameter))
(constant_declaration (identifier) @definition.constant)
(constant_declaration (operator_declaration name: (_) @definition.constant))
(function_definition
  name: (identifier) @definition.function
  (#set! "definition.function.scope" "parent"))
(lambda (identifier) @definition.parameter)
(module_definition
  name: (_) @definition.import
  (#set! "definition.import.scope" "parent"))
(module_definition parameter: (identifier) @definition.parameter)
(module_definition parameter: (operator_declaration name: (_) @definition.parameter))
(operator_definition
  name: (_) @definition.macro
  (#set! "definition.macro.scope" "parent"))
(operator_definition parameter: (identifier) @definition.parameter)
(operator_definition parameter: (operator_declaration name: (_) @definition.parameter))
(quantifier_bound (identifier) @definition.parameter)
(quantifier_bound (tuple_of_identifiers (identifier) @definition.parameter))
(unbounded_quantification (identifier) @definition.parameter)
(variable_declaration (identifier) @definition.var)

; Proof scopes and definitions
[
  (non_terminal_proof)
  (suffices_proof_step)
  (theorem)
] @scope

(assume_prove (new (identifier) @definition.parameter))
(assume_prove (new (operator_declaration name: (_) @definition.parameter)))
(assumption name: (identifier) @definition.constant)
(pick_proof_step (identifier) @definition.parameter)
(take_proof_step (identifier) @definition.parameter)
(theorem
  name: (identifier) @definition.constant
  (#set! "definition.constant.scope" "parent"))

; PlusCal scopes and definitions
[
  (pcal_algorithm)
  (pcal_macro)
  (pcal_procedure)
  (pcal_with)
] @scope

(pcal_macro_decl parameter: (identifier) @definition.parameter)
(pcal_proc_var_decl (identifier) @definition.parameter)
(pcal_var_decl (identifier) @definition.var)
(pcal_with (identifier) @definition.parameter)

; Built-in PlusCal variables
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
((prefix_op_symbol) @reference)
(bound_prefix_op symbol: (_) @reference)
((infix_op_symbol) @reference)
(bound_infix_op symbol: (_) @reference)
((postfix_op_symbol) @reference)
(bound_postfix_op symbol: (_) @reference)
(bound_nonfix_op symbol: (_) @reference)
