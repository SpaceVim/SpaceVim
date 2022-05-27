;; Comments
(comment) @comment

;; Generic Key-value pairs and dictionary keywords
(key_value
    keyword: (identifier) @function
)
(dict
    key: (identifier) @type
)

;; Macros
(macro
    "$" @conditional
    (prev_scope)* @conditional
    (identifier)* @namespace
)


;; Directives
"#" @conditional
(preproc_call
    directive: (identifier)* @conditional
    argument: (identifier)* @namespace
)
(
    (preproc_call
        argument: (identifier)* @namespace
    ) @conditional
    (#match? @conditional "ifeq")
)
(
    (preproc_call) @conditional
    (#match? @conditional "(else|endif)")
)

;; Literal numbers and strings
(number_literal) @float
(string_literal) @string
(escape_sequence) @string.escape

;; Treat [m^2 s^-2] the same as if it was put in numbers format
(dimensions dimension: (identifier) @float)

;; Punctuation
[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "#{"
  "#}"
  "|-"
  "-|"
  "<!--("
  ")-->"
  "$$"
] @punctuation.bracket

[
  ";"
] @punctuation.delimiter

;; Special identifiers
([(identifier) "on" "off" "true" "false" "yes" "no"] @constant.builtin
(#match? @constant.builtin "^(uniform|non-uniform|and|or|on|off|true|false|yes|no)$")
)
