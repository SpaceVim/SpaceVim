(variable) @variable
(identifier) @variable
((variable) @variable.builtin
 (#eq? @variable.builtin "$this"))

(braced_expression) @none

(scoped_identifier
 (qualified_identifier 
   (identifier) @type))

(comment) @comment
(heredoc) @comment

[
 "function"
] @keyword.function

[
 "async"
 "await"
 "type"
 "interface"
 "implements"
 "class"
 "protected"
 "private"
 "public"
 "using"
 "namespace"
 "attribute"
 "const"
 (xhp_modifier)
 (final_modifier)
 "extends"
 "insteadof"
] @keyword

"use" @include

[
  "new"
  "print"
  "echo"
  "newtype"
  "clone"
  "as"
] @keyword.operator

[
 "return"
] @keyword.return

[
  "shape"
  "tuple"
  (array_type)
  "bool"
  "float"
  "int"
  "string"
  "arraykey"
  "void"
  "nonnull"
  "mixed"
  "dynamic"
  "noreturn"
] @type.builtin

[
  (null)
] @constant.builtin

[
  (true)
  (false)
] @boolean

(type_specifier) @type
(new_expression
  (_) @type)

(alias_declaration "newtype" . (_) @type)
(alias_declaration "type" . (_) @type)

(class_declaration
  name: (identifier) @type)
(type_parameter
  name: (identifier) @type)

(collection
  (qualified_identifier
    (identifier) @type .))

(attribute_modifier) @attribute
[
 "@required"
 "@lateinit"
] @attribute

[
  "="
  "??="
  ".="
  "|="
  "^="
  "&="
  "<<="
  ">>="
  "+="
  "-="
  "*="
  "/="
  "%="
  "**="

  "==>"
  "|>"
  "??"
  "||"
  "&&"
  "|"
  "^"
  "&"
  "=="
  "!="
  "==="
  "!=="
  "<"
  ">"
  "<="
  ">="
  "<=>"
  "<<"
  ">>"
  "->"
  "+"
  "-"
  "."
  "*"
  "/"
  "%"
  "**"

  "++"
  "--"
  "!"

  "?:"

  "="
  "??="
  ".="
  "|="
  "^="
  "&="
  "<<="
  ">>="
  "+="
  "-="
  "*="
  "/="
  "%="
  "**="
  "=>"

  ;; type modifiers
  "@"
  "?"
  "~"
] @operator

(integer) @number
(float) @float

(parameter
  (variable) @parameter)

(call_expression
  function: (qualified_identifier (identifier) @function .))

(call_expression
  function: (scoped_identifier (identifier)  @function .))

(call_expression
  function: (selection_expression
              (qualified_identifier (identifier) @method .)))

(qualified_identifier
  (_) @namespace .
  (_))

(use_statement
  (qualified_identifier
  (_) @namespace .)
  (use_clause))

(use_statement
  (use_type "namespace")
  (use_clause
    (qualified_identifier
         (identifier) @namespace .)
    alias: (identifier)? @namespace))

(use_statement
  (use_type "const")
  (use_clause
    (qualified_identifier
         (identifier) @constant .)
    alias: (identifier)? @constant))

(use_statement
  (use_type "function")
  (use_clause
    (qualified_identifier
         (identifier) @function .)
    alias: (identifier)? @function))

(use_statement
  (use_type "type")
  (use_clause
    (qualified_identifier
         (identifier) @type .)
    alias: (identifier)? @type))

(use_clause
  (use_type "namespace")
  (qualified_identifier
  (_) @namespace .)
  alias: (identifier)? @namespace)

(use_clause
  (use_type "function")
  (qualified_identifier
  (_) @function .)
  alias: (identifier)? @function)

(use_clause
  (use_type "const")
  (qualified_identifier
  (_) @constant .)
  alias: (identifier)? @constant)

(use_clause
  (use_type "type")
  (qualified_identifier
  (_) @type .)
  alias: (identifier)? @type)

(function_declaration
  name: (identifier) @function)
(method_declaration
  name: (identifier) @method)

(type_arguments
  [ "<" ">" ] @punctuation.bracket)
[ "(" ")" "[" "]" "{" "}" "<<" ">>"] @punctuation.bracket

(xhp_open
  [ "<" ">" ] @tag.delimiter)
(xhp_close
  [ "</" ">" ] @tag.delimiter)

[ "." ";" "::" ":" "," ] @punctuation.delimiter

(ternary_expression
  ["?" ":"] @conditional)

[
  "if"
  "else"
  "elseif"
  "switch"
  "case"
] @conditional

[
  "try"
  "catch"
  "finally"
] @exception

[
  "for"
  "while"
  "foreach"
  "do"
  "continue"
  "break"
] @repeat

[
 (string)
 (xhp_string)
] @string

[
 (xhp_open)
 (xhp_close)
] @tag

(ERROR) @error
