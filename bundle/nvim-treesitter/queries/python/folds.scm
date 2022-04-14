(function_definition (block) @fold)
(class_definition (block) @fold)

(while_statement (block) @fold)
(for_statement (block) @fold)
(if_statement (block) @fold)
(with_statement (block) @fold)
(try_statement (block) @fold)

[
  (import_from_statement)
  (parameters)
  (argument_list)

  (parenthesized_expression)
  (generator_expression)
  (list_comprehension)
  (set_comprehension)
  (dictionary_comprehension)

  (tuple)
  (list)
  (set)
  (dictionary)

  (string)
] @fold
