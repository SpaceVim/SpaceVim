; Variables

(variable_name) @variable

; Types

[
 (primitive_type)
 (cast_type)
 ] @type.builtin
(named_type (name)) @type
(named_type (qualified_name)) @type
(class_declaration
  name: (name) @type)
(base_clause
  [(name) (qualified_name)] @type)
(enum_declaration
  name: (name) @type)
(interface_declaration
  name: (name) @type)
(namespace_use_clause
  [(name) (qualified_name)] @type)
(namespace_aliasing_clause (name)) @type
(class_interface_clause
  [(name) (qualified_name)] @type)
(scoped_call_expression
  scope: [(name) (qualified_name)] @type)
(class_constant_access_expression
  . [(name) (qualified_name)] @type
  (name) @constant)
(trait_declaration
  name: (name) @type)
(use_declaration
    (name) @type)

; Functions, methods, constructors

(array_creation_expression "array" @function.builtin)
(list_literal "list" @function.builtin)

(method_declaration
  name: (name) @method)

(function_call_expression
  function: (qualified_name (name)) @function)

(function_call_expression
  (name) @function)

(scoped_call_expression
  name: (name) @function)

(member_call_expression
  name: (name) @method)

(function_definition
  name: (name) @function)

(nullsafe_member_call_expression
    name: (name) @method)

(method_declaration
    name: (name) @constructor
    (#eq? @constructor "__construct"))
(object_creation_expression
  [(name) (qualified_name)] @constructor)

; Parameters
[
  (simple_parameter)
  (variadic_parameter)
] @parameter

(argument
    (name) @parameter)

; Member

(property_element
  (variable_name) @property)

(member_access_expression
  name: (variable_name (name)) @property)

(member_access_expression
  name: (name) @property)

; Variables

(relative_scope) @variable.builtin

((name) @constant
 (#vim-match? @constant "^_?[A-Z][A-Z\d_]*$"))
((name) @constant.builtin
 (#vim-match? @constant.builtin "^__[A-Z][A-Z\d_]+__$"))

(const_declaration (const_element (name) @constant))

((name) @variable.builtin
 (#eq? @variable.builtin "this"))

; Namespace
(namespace_definition
  name: (namespace_name) @namespace)

; Conditions ( ? : )
(conditional_expression) @conditional
; Basic tokens

[
 (string)
 (heredoc)
 (shell_command_expression) ; backtick operator: `ls -la`
 ] @string
(encapsed_string (escape_sequence) @string.escape)

(boolean) @boolean
(null) @constant.builtin
(integer) @number
(float) @float
(comment) @comment

(named_label_statement) @label
; Keywords

[
 "and"
 "as"
 "instanceof"
 "or"
 "xor"
] @keyword.operator

[
 "fn"
 "function"
] @keyword.function

[
 "$"
 "abstract"
 "break"
 "class"
 "clone"
 "const"
 "declare"
 "default"
 "echo"
 "enddeclare"
 "enum"
 "extends"
 "final"
 "global"
 "goto"
 "implements"
 "insteadof"
 "interface"
 "namespace"
 "new"
 "private"
 "protected"
 "public"
 "static"
 "trait"
 "unset"
 ] @keyword

[
  "return"
  "yield"
] @keyword.return

[
 "case"
 "else"
 "elseif"
 "endif"
 "endswitch"
 "if"
 "switch"
 "match"
  "??"
 ] @conditional

[
 "continue"
 "do"
 "endfor"
 "endforeach"
 "endwhile"
 "for"
 "foreach"
 "while"
 ] @repeat

[
 "catch"
 "finally"
 "throw"
 "try"
 ] @exception

[
 "include_once"
 "include"
 "require_once"
 "require"
 "use"
 ] @include

[
 ","
 ";"
 ] @punctuation.delimiter

[
 (php_tag)
 "?>"
 "("
 ")"
 "["
 "]"
 "{"
 "}"
 ] @punctuation.bracket

[
  "="

  "."
  "-"
  "*"
  "/"
  "+"
  "%"
  "**"

  "~"
  "|"
  "^"
  "&"
  "<<"
  ">>"

  "->"
  "?->"

  "=>"

  "<"
  "<="
  ">="
  ">"
  "<>"
  "=="
  "!="
  "==="
  "!=="

  "!"
  "&&"
  "||"

  ".="
  "-="
  "+="
  "*="
  "/="
  "%="
  "**="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  "??="
  "--"
  "++"

  "@"
  "::"
] @operator

(ERROR) @error
