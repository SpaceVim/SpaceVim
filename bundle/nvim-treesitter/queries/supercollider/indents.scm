[
  (function_block)
  (binary_expression)
  (collection)
  (indexed_collection)
  (parameter_call_list)
  (function_call)
  (class_def)
  (classvar)
  (const)
  (instance_var)
  (variable_definition)
  (variable_definition_sequence (variable_definition))
  (control_structure)
  (return_statement)
] @indent.begin

[
  (parameter_call_list (argument_calls))
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @indent.branch

[
  (block_comment)
  (line_comment)
] @indent.ignore
