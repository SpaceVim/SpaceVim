; inherits: c

[
  (class_specifier)
  (condition_clause)
] @indent.begin

((field_initializer_list) @indent.begin
  (#set! indent.start_at_same_line 1))
(access_specifier) @indent.branch

