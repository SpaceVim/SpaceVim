(comment) @comment
(number) @number 
(bool) @boolean

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
]
@punctuation.bracket

[
  ":"
  ","
  "."
] @punctuation.delimiter

[
  "and"
  "not"
  "or"
  "in"
] @keyword.operator

[
  "="
  "=="
  "!="
  "+"
  "/"
  "/="
  "+="
  "-="
  ">"
  ">="
] @operator

[
  "if"
  "elif"
  "else"
  "endif"
] @conditional

[
  "foreach"
  "endforeach"
  (keyword_break)
  (keyword_continue)
] @repeat

;;; format
(string) @string
["@"] @punctuation.special

(experession_statement
  object: (identifier) @variable)

(normal_command
  command: (identifier) @function)

(list
  variable: (identifier) @variable)

(operatorunit
  (identifier) @variable)

(formatunit
  variable: (identifier) @variable)

(variableunit
  value: (identifier) @variable)
(pair
  key: (identifier) @property)
(pair
  value: (identifier) @variable)

(escape_sequence) @string.escape
