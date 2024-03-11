[
  (mod_item)
  (struct_item)
  (enum_item)
  (impl_item)
  (for_expression)
  (struct_expression)
  (match_expression)
  (tuple_expression)
  (match_arm)
  (match_block)
  (call_expression)
  (assignment_expression)
  (arguments)
  (block)
  (where_clause)
  (use_list)
  (array_expression)
  (ordered_field_declaration_list)
  (field_declaration_list)
  (enum_variant_list)
  (parameters)
  (token_tree)
  (macro_definition)
] @indent.begin
(trait_item body: (_) @indent.begin)
(string_literal (escape_sequence)) @indent.begin

(block "}" @indent.end)
(enum_item
  body: (enum_variant_list "}" @indent.end))
(impl_item
  body: (declaration_list "}" @indent.end))
(match_expression
  body: (match_block "}" @indent.end))
(mod_item
  body: (declaration_list "}" @indent.end))
(struct_item
  body: (field_declaration_list "}" @indent.end))
(trait_item
  body: (declaration_list "}" @indent.end))

(impl_item (where_clause) @indent.dedent)

[
  "where"
  ")"
  "]"
  "}"
] @indent.branch
(impl_item (declaration_list) @indent.branch)

[
  (line_comment)
  (string_literal)
] @indent.ignore


(raw_string_literal) @indent.auto

