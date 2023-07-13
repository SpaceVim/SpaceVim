; Functions

(function_definition
  function_name: (identifier) @function
  (end) @keyword.function)

(parameter_list (identifier) @parameter)

; Keywords

((identifier) @keyword
  (#eq? @keyword "end"))

(function_keyword) @keyword.function

[
  "return"
] @keyword.return

; Conditionals

[
  "if"
  "elseif"
  "else"
  "switch"
  "case"
  "otherwise"
] @conditional

(if_statement (end) @conditional)
(switch_statement (end) @conditional)

; Repeats

[
  "for" 
  "while"
  "break"
  "continue"
] @repeat

(for_statement (end) @repeat)
(while_statement (end) @repeat)

; Exceptions

[
  "try"
  "catch"
] @exception

(try_statement (end) @exception)

; Punctuation

[
  ","
  ";"
  ":"
] @punctuation.delimiter

[ "{" "}" ] @punctuation.bracket

[ "[" "]" ] @punctuation.bracket

[ "(" ")" ] @punctuation.bracket

; Operators

[ 
  ">"
  "<"
  "=="
  "<="
  ">="
  "=<"
  "=>"
  "~="
  "*"
  ".*"
  "/"
  "\\"
  "./"
  "^"
  ".^"
  "+"
  "="
  "&&"
  "||"
] @operator

; Literals

(number) @number

(string) @string

[ "true" "false" ] @boolean

; Comments

(comment) @comment @spell

; Errors

(ERROR) @error
