(simple_expansion) @none
(expansion
  "${" @punctuation.special
  "}" @punctuation.special) @none
[
 "("
 ")"
 "(("
 "))"
 "{"
 "}"
 "["
 "]"
 "[["
 "]]"
 ] @punctuation.bracket

[
 ";"
 ";;"
 (heredoc_start)
 ] @punctuation.delimiter

[
 "$"
] @punctuation.special

[
 ">"
 ">>"
 "<"
 "<<"
 "&"
 "&&"
 "|"
 "||"
 "="
 "=~"
 "=="
 "!="
 ] @operator

[
 (string)
 (raw_string)
 (heredoc_body)
] @string

(variable_assignment (word) @string)

[
 "if"
 "then"
 "else"
 "elif"
 "fi"
 "case"
 "in"
 "esac"
 ] @conditional

[
 "for"
 "do"
 "done"
 "while"
 ] @repeat

[
 "declare"
 "export"
 "local"
 "readonly"
 "unset"
 ] @keyword

"function" @keyword.function

(special_variable_name) @constant

((word) @constant.builtin
 (#match? @constant.builtin "^SIG(INT|TERM|QUIT|TIN|TOU|STP|HUP)$"))

((word) @boolean
  (#match? @boolean "^(true|false)$"))

(comment) @comment
(test_operator) @string

(command_substitution
  [ "$(" ")" ] @punctuation.bracket)

(process_substitution
  [ "<(" ")" ] @punctuation.bracket)


(function_definition
  name: (word) @function)

(command_name (word) @function)

((command_name (word) @function.builtin)
 (#any-of? @function.builtin
    "alias" "cd" "clear" "echo" "eval" "exit" "getopts" "popd"
    "pushd" "return" "set" "shift" "shopt" "source" "test"))

(command
  argument: [
             (word) @parameter
             (concatenation (word) @parameter)
             ])

((word) @number
  (#lua-match? @number "^[0-9]+$"))

(file_redirect
  descriptor: (file_descriptor) @operator
  destination: (word) @parameter)

(expansion
  [ "${" "}" ] @punctuation.bracket)

(variable_name) @variable

((variable_name) @constant
 (#lua-match? @constant "^[A-Z][A-Z_0-9]*$"))

(case_item
  value: (word) @parameter)

(regex) @string.regex
