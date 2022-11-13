(identifier) @variable
(int_literal) @number
(float_literal) @float
(bool_literal) @boolean

(type_declaration) @type

(function_declaration
    (identifier) @function)

(parameter
    (variable_identifier_declaration (identifier) @parameter))

(struct_declaration
    (identifier) @type)
	
(struct_declaration
	(struct_member (variable_identifier_declaration (identifier) @field)))

(type_constructor_or_function_call_expression
    (type_declaration) @function)

[
    "struct"
    "bitcast"
    "discard"
    "enable"
    "fallthrough"
    "fn"
    "let"
    "private"
    "read"
    "read_write"
    "storage"
    "type"
    "uniform"
    "var"
    "workgroup"
    "write"
    "override"
    (texel_format)
] @keyword

"fn" @keyword.function

"return" @keyword.return

[ "," "." ":" ";" ] @punctuation.delimiter

["(" ")" "[" "]" "{" "}"] @punctuation.bracket

[
    "loop"
    "for"
    "while"
    "break"
    "continue"
    "continuing"
] @repeat

[
    "if"
    "else"
    "switch"
    "case"
    "default"
] @conditional

[
    "&"
    "&&"
    "/"
    "!"
    "="
    "=="
    "!="
    ">"
    ">="
    ">>"
    "<"
    "<="
    "<<"
    "%"
    "-"
    "+"
    "|"
    "||"
    "*"
    "~"
    "^"
    "@"
    "++"
    "--"
] @operator

(attribute
    (identifier) @attribute)

(comment) @comment

(ERROR) @error
