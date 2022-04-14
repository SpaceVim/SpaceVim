(variable) @variable

[
 "datasource"
 "enum"
 "generator"
 "model"
 "type"
] @keyword

[
  (comment)
  (developer_comment)
] @comment

[
  (attribute)
  (call_expression)
] @function

(arguments) @property
(column_type) @type
(enumeral) @constant
(column_declaration (identifier) @variable)
(string) @string

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  "="
  "@"
] @operator
