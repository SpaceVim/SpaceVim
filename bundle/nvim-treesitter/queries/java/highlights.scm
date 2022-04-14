; CREDITS @maxbrunsfeld (maxbrunsfeld@gmail.com)

; Variables

(identifier) @variable

; Methods

(method_declaration
  name: (identifier) @method)
(method_invocation
  name: (identifier) @method)

(super) @function.builtin

; Parameters
(formal_parameter
  name: (identifier) @parameter)
(catch_formal_parameter
  name: (identifier) @parameter)

(spread_parameter
 (variable_declarator) @parameter) ; int... foo

;; Lambda parameter
(inferred_parameters (identifier) @parameter) ; (x,y) -> ...
(lambda_expression
    parameters: (identifier) @parameter) ; x -> ...


; Annotations


(annotation
  name: (identifier) @attribute)
(marker_annotation
  name: (identifier) @attribute)


; Operators

[
"@"
"+"
":"
"++"
"-"
"--"
"&"
"&&"
"|"
"||"
"!="
"=="
"*"
"/"
"%"
"<"
"<="
">"
">="
"="
"-="
"+="
"*="
"/="
"%="
"->"
"^"
"^="
"&="
"|="
"~"
">>"
">>>"
"<<"
"::"
] @operator

; Types

(interface_declaration
  name: (identifier) @type)
(class_declaration
  name: (identifier) @type)
(record_declaration
  name: (identifier) @type)
(enum_declaration
  name: (identifier) @type)
(constructor_declaration
  name: (identifier) @type)
(type_identifier) @type
((method_invocation
  object: (identifier) @type)
 (#lua-match? @type "^[A-Z]"))
((method_reference
  . (identifier) @type)
 (#lua-match? @type "^[A-Z]"))



((field_access
  object: (identifier) @type)
  (#lua-match? @type "^[A-Z]"))
((scoped_identifier
  scope: (identifier) @type)
  (#lua-match? @type "^[A-Z]"))

; Fields

(field_declaration
  declarator: (variable_declarator) @field)

(field_access
  field: (identifier) @field)

[
(boolean_type)
(integral_type)
(floating_point_type)
(void_type)
] @type.builtin

; Variables

((identifier) @constant
  (#lua-match? @constant "^[A-Z_][A-Z%d_]+$"))

(this) @variable.builtin

; Literals

[
(hex_integer_literal)
(decimal_integer_literal)
(octal_integer_literal)
(binary_integer_literal)
] @number

[
(decimal_floating_point_literal)
(hex_floating_point_literal)
] @float

(character_literal) @character
(string_literal) @string
(null_literal) @constant.builtin

[
  (line_comment)
  (block_comment)
] @comment

[
(true)
(false)
] @boolean

; Keywords

[
"abstract"
"assert"
"break"
"class"
"record"
"continue"
"default"
"enum"
"exports"
"extends"
"final"
"implements"
"instanceof"
"interface"
"module"
"native"
"open"
"opens"
"package"
"private"
"protected"
"provides"
"public"
"requires"
"static"
"strictfp"
"synchronized"
"to"
"transient"
"transitive"
"uses"
"volatile"
"with"
] @keyword

[
"return"
"yield"
] @keyword.return

[
 "new"
] @keyword.operator

; Conditionals

[
"if"
"else"
"switch"
"case"
] @conditional

(ternary_expression ["?" ":"] @conditional)

;

[
"for"
"while"
"do"
] @repeat

; Includes

"import" @include
"package" @include

; Punctuation

[
";"
"."
"..."
","
] @punctuation.delimiter

[
"["
"]"
"{"
"}"
"("
")"
] @punctuation.bracket

; Exceptions

[
"throw"
"throws"
"finally"
"try"
"catch"
] @exception

; Labels
(labeled_statement
  (identifier) @label)
