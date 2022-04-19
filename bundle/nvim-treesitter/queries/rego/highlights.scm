; highlights.scm
"import" @include
"package" @include


(reserved_keywords) @keyword
(comment) @comment
(rego_block rego_rule_name: (identifier) @function)
(builtin_function function_name: (function_name) @function.builtin)
(opening_parameter) @punctuation.bracket
(closing_parameter) @punctuation.bracket
(string_definition) @string
(number) @number
(operator) @operator
(true) @boolean
(false) @boolean
