[
  (mod_item)
  (struct_item)
  (enum_item)
  (impl_item)
  (struct_expression)
  (match_expression)
  (tuple_expression)
  (match_arm)
  (match_block)
  (call_expression)
  (assignment_expression)
  (arguments)
  (block)
  (use_list)
  (field_declaration_list)
  (enum_variant_list)
  (tuple_pattern)
] @indent.begin

(import_statement "(") @indent.begin

(block "}" @indent.end)
(enum_item
  body: (enum_variant_list "}" @indent.end))
(match_expression
  body: (match_block "}" @indent.end))
(mod_item
  body: (declaration_list "}" @indent.end))
(struct_item
  body: (field_declaration_list "}" @indent.end))
(trait_item
  body: (declaration_list "}" @indent.end))

[
  ")"
  "]"
  "}"
] @indent.branch

[
  (comment)
  (string)
  (short_string)
] @indent.ignore
