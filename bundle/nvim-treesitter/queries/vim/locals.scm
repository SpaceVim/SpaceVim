[
  (script_file)
  (function_definition)
] @scope

(function_declaration name: (identifier) @definition.function)
(function_declaration parameters: (parameters (identifier) @definition.parameter))
(let_statement [(scoped_identifier) (identifier)] @definition.var)

(identifier) @reference
