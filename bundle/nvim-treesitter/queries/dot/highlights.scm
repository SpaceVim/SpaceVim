(identifier) @type
(keyword) @keyword
(string_literal) @string
(number_literal) @number

[
  (edgeop)
  (operator)
] @operator

[
  ","
  ";"
] @punctuation.delimiter

[
  "{"
  "}"
  "["
  "]"
  "<"
  ">"
] @punctuation.bracket

(subgraph
  id: (id
    (identifier) @namespace)
)

(attribute
  name: (id
    (identifier) @field)
)

(attribute
  value: (id
    (identifier) @constant)
)

[
(comment)
(preproc)
] @comment

(ERROR) @error
