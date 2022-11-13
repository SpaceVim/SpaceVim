; Variables
(identifier) @variable

; Keywords

[
 "alias"
 "begin"
 "break"
 "class"
 "def"
 "do"
 "end"
 "ensure"
 "module"
 "next"
 "rescue"
 "retry"
 "then"
 ] @keyword

[
 "return"
 "yield"
] @keyword.return

[
 "and"
 "or"
 "in"
 "not"
] @keyword.operator

[
 "case"
 "else"
 "elsif"
 "if"
 "unless"
 "when"
 ] @conditional

[
 "for"
 "until"
 "while"
 ] @repeat

(constant) @type

((identifier) @keyword
 (#vim-match? @keyword "^(private|protected|public)$"))

[
 "rescue"
 "ensure"
 ] @exception

((identifier) @exception
 (#vim-match? @exception "^(fail|raise)$"))

; Function calls

"defined?" @function

(call
   receiver: (constant)? @type
   method: [
            (identifier)
            (constant)
            ] @function
   )

(program
 (call
  (identifier) @include)
 (#vim-match? @include "^(require|require_relative|load)$"))

; Function definitions

(alias (identifier) @function)
(setter (identifier) @function)

(method name: [
               (identifier) @function
               (constant) @type
               ])

(singleton_method name: [
                         (identifier) @function
                         (constant) @type
                         ])

(class name: (constant) @type)
(module name: (constant) @type)
(superclass (constant) @type)

; Identifiers
[
 (class_variable)
 (instance_variable)
 ] @label

((identifier) @constant.builtin
 (#vim-match? @constant.builtin "^__(callee|dir|id|method|send|ENCODING|FILE|LINE)__$"))

((constant) @type
 (#vim-match? @type "^[A-Z\\d_]+$"))

[
 (self)
 (super)
 ] @variable.builtin

(method_parameters (identifier) @parameter)
(lambda_parameters (identifier) @parameter)
(block_parameters (identifier) @parameter)
(splat_parameter (identifier) @parameter)
(hash_splat_parameter (identifier) @parameter)
(optional_parameter (identifier) @parameter)
(destructured_parameter (identifier) @parameter)
(block_parameter (identifier) @parameter)
(keyword_parameter (identifier) @parameter)

; TODO: Re-enable this once it is supported
; ((identifier) @function
;  (#is-not? local))

; Literals

[
 (string)
 (bare_string)
 (subshell)
 (heredoc_body)
 ] @string

[
 (bare_symbol)
 (heredoc_beginning)
 (heredoc_end)
 ] @constant

[
 (simple_symbol)
 (delimited_symbol)
 (hash_key_symbol)
 ] @symbol

(pair key: (hash_key_symbol) ":" @constant)
(regex) @string.regex
(escape_sequence) @string.escape
(integer) @number
(float) @float

[
 (nil)
 (true)
 (false)
 ] @boolean

(comment) @comment

; Operators

[
 "!"
 "="
 "=="
 "==="
 "<=>"
 "=>"
 "->"
 ">>"
 "<<"
 ">"
 "<"
 ">="
 "<="
 "**"
 "*"
 "/"
 "%"
 "+"
 "-"
 "&"
 "|"
 "^"
 "&&"
 "||"
 "||="
 "&&="
 "!="
 "%="
 "+="
 "-="
 "*="
 "/="
 "=~"
 "!~"
 "?"
 ":"
 ".."
 "..."
 ] @operator

[
 ","
 ";"
 "."
 ] @punctuation.delimiter

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
 "%w("
 "%i("
 ] @punctuation.bracket

(interpolation
  "#{" @punctuation.special
  "}" @punctuation.special) @none

(ERROR) @error
