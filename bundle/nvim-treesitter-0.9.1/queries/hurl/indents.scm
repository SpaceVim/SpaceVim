; indents.scm

[
  (json_object)
  (json_array)
] @indent.begin

[
  "}"
  "]"
] @indent.branch

(xml_tag) @indent.begin
(xml_close_tag) @indent.branch
