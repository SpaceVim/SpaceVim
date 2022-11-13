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
] @indent
(trait_item body: (_) @indent)
(string_literal (escape_sequence)) @indent

(block "}" @indent_end)
(enum_item
  body: (enum_variant_list "}" @indent_end))
(impl_item
  body: (declaration_list "}" @indent_end))
(match_expression
  body: (match_block "}" @indent_end))
(mod_item
  body: (declaration_list "}" @indent_end))
(struct_item
  body: (field_declaration_list "}" @indent_end))
(trait_item
  body: (declaration_list "}" @indent_end))

(impl_item (where_clause) @dedent)

[
  "where"
  ")"
  "]"
  "}"
] @branch
(impl_item (declaration_list) @branch)

[
  (line_comment)
  (string_literal)
] @ignore


(raw_string_literal) @auto
