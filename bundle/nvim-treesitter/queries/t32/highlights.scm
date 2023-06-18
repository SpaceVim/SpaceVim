[
  "="
  "^^"
  "||"
  "&&"
  "+"
  "-"
  "*"
  "/"
  "%"
  "|"
  "^"
  "=="
  "!="
  ">"
  ">="
  "<="
  "<"
  "<<"
  ">>"
  ".."
  "--"
  "++"
  "+"
  "-"
  "~"
  "!"
  "&"
  "->"
  "*"
] @operator

[
 "("
 ")"
 "{"
 "}"
 "["
 "]"
] @punctuation.bracket

[
  ","
  "."
  ";"
] @punctuation.delimiter

[
  (access_class)
  (address)
  (bitmask)
  (file_handle)
  (frequency)
  (integer)
  (percentage)
  (time)
] @number

(float) @float

(string) @string

(path) @string.special

(symbol) @symbol

(character) @character

; Commands
(command_expression
  command: (identifier) @keyword)
(macro_definition
  command: (identifier) @keyword)

; Returns
(
  (command_expression
    command: (identifier) @keyword.return)
  (#match? @keyword.return "^[eE][nN][dD]([dD][oO])?$")
)
(
  (command_expression
    command: (identifier) @keyword.return)
  (#lua-match? @keyword.return "^[rR][eE][tT][uU][rR][nN]$")
)

; Subroutine calls
(subroutine_call_expression
  command: (identifier) @keyword
  subroutine: (identifier) @function.call)

; Variables, constants and labels
(macro) @variable.builtin
(internal_c_variable) @variable.builtin

(argument_list
  (identifier) @constant)
(
 (argument_list (identifier) @constant.builtin)
 (#lua-match? @constant.builtin "^[%%/][%l%u][%l%u%d.]*$")
)

(
  (command_expression
    command: (identifier) @keyword
    arguments: (argument_list . (identifier) @label))
  (#lua-match? @keyword "^[gG][oO][tT][oO]$")
)
(labeled_expression
  label: (identifier) @label)

; Subroutine blocks
(subroutine_block
  command: (identifier) @keyword
  subroutine: (identifier) @function)

(labeled_expression
  label: (identifier) @function
  (block))

; Parameter declarations
(parameter_declaration
  command: (identifier) @keyword
  (identifier)? @constant.builtin
  macro: (macro) @parameter)

; Control flow
(if_block
  command: (identifier) @conditional)
(else_block
  command: (identifier) @conditional)

(while_block
  command: (identifier) @repeat)
(repeat_block
  command: (identifier) @repeat)

(call_expression
  function: (identifier) @function.builtin)

(type_identifier) @type
(comment) @comment @spell
