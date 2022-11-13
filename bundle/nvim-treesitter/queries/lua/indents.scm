[
  (function_definition)
  (function_declaration)
  (field)
  (do_statement)
  (method_index_expression)
  (while_statement)
  (repeat_statement)
  (if_statement)
  "then"
  (for_statement)
  (return_statement)
  (table_constructor)
  (arguments)
  (return_statement)
] @indent

[
  "end"
  ")"
  "}"
] @indent_end

(return_statement
  (expression_list
    (function_call))) @dedent

[
  "end"
  "then"
  "until"
  "}"
  ")"
  "elseif"
  (elseif_statement)
  "else"
  (else_statement)
] @branch

(comment) @auto

(string) @auto
