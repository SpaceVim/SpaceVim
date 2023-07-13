[
  (annotation_targets)
  (const)
  (enum)
  (interface)
  (implicit_generics)
  (generics)
  (group)
  (method_parameters)
  (named_return_types)
  (struct)
  (union)
  (field)
] @indent.begin

((struct_shorthand (property)) @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

((method (field_version)) @indent.align
  (#set! indent.open_delimiter field_version))

((const_list (const_value)) @indent.align
  (#set! indent.open_delimiter "[")
  (#set! indent.close_delimiter "]"))

(concatenated_string) @indent.align

[
  "}"
  ")"
] @indent.end @indent.branch


[
  (ERROR)
  (comment)
] @indent.auto
