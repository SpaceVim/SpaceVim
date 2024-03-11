(block) @scope

; Parameter definitions
(parameter_declaration
  command: (identifier)
  macro: (macro) @definition.parameter)

; Variable definitions
(macro_definition
  command: (identifier)
  macro: (macro) @definition.var)

(command_expression
  command: (identifier)
  arguments: (argument_list
    declarator: (trace32_hll_variable) @definition.var))

; Function definitions
(subroutine_block
  command: (identifier)
  subroutine: (identifier) @definition.function)

(labeled_expression
  label: (identifier) @definition.function
  (block))

; References
(
  (subroutine_call_expression
    command: (identifier)
    subroutine: (identifier) @reference)
  (#set! reference.kind "function")
)

[
  (macro)
  (trace32_hll_variable)
] @reference
