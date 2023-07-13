; adapted from https://github.com/Beaglefoot/tree-sitter-awk

[
  (identifier)
  (field_ref)
] @variable
(field_ref (_) @variable)

(number) @number

(string) @string
(regex) @string.regex
(escape_sequence) @string.escape

(comment) @comment @spell

(ns_qualified_name (namespace) @namespace)
(ns_qualified_name "::" @punctuation.delimiter)

(func_def name: (_ (identifier) @function) @function)
(func_call name: (_ (identifier) @function) @function)

(func_def (param_list (identifier) @parameter))

[
  "print"
  "printf"
  "getline"
] @function.builtin

[
  (delete_statement)
  (break_statement)
  (continue_statement)
  (next_statement)
  (nextfile_statement)
] @keyword

[
  "func"
  "function"
] @keyword.function

[
  "return"
  "exit"
] @keyword.return

[
  "do"
  "while"
  "for"
  "in"
] @repeat

[
  "if"
  "else"
  "switch"
  "case"
  "default"
] @conditional

[
  "@include"
  "@load"
] @include

"@namespace" @preproc

[
 "BEGIN"
 "END"
 "BEGINFILE"
 "ENDFILE"
] @label

(binary_exp [
  "^"
  "**"
  "*"
  "/"
  "%"
  "+"
  "-"
  "<"
  ">"
  "<="
  ">="
  "=="
  "!="
  "~"
  "!~"
  "in"
  "&&"
  "||"
] @operator)

(unary_exp [
  "!"
  "+"
  "-"
] @operator)

(assignment_exp [
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "^="
] @operator)

(ternary_exp [
  "?"
  ":"
] @conditional.ternary)

(update_exp [
  "++"
  "--"
] @operator)

(redirected_io_statement [
  ">"
  ">>"
] @operator)

(piped_io_statement [
  "|"
  "|&"
] @operator)

(piped_io_exp [
  "|"
  "|&"
] @operator)

(field_ref "$" @punctuation.delimiter)

(regex "/" @punctuation.delimiter)
(regex_constant "@" @punctuation.delimiter)

[ ";" "," ] @punctuation.delimiter

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket
