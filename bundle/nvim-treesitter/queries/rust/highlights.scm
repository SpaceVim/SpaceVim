; Forked from https://github.com/tree-sitter/tree-sitter-rust
; Copyright (c) 2017 Maxim Sokolov
; Licensed under the MIT license.

; Identifier conventions

(identifier) @variable
((identifier) @type
 (#lua-match? @type "^[A-Z]"))
(const_item
  name: (identifier) @constant)
; Assume all-caps names are constants
((identifier) @constant
 (#lua-match? @constant "^[A-Z][A-Z%d_]*$"))

; Other identifiers

(type_identifier) @type
(primitive_type) @type.builtin
(field_identifier) @field
(shorthand_field_initializer
  (identifier) @field)
(mod_item
 name: (identifier) @namespace)

(self) @variable.builtin

(lifetime   ["'" (identifier)] @label)
(loop_label ["'" (identifier)] @label)


; Function definitions

(function_item (identifier) @function)
(function_signature_item (identifier) @function)

(parameter (identifier) @parameter)
(closure_parameters (_) @parameter)

; Function calls
(call_expression
  function: (identifier) @function)
(call_expression
  function: (scoped_identifier
              (identifier) @function .))
(call_expression
  function: (field_expression
    field: (field_identifier) @function))

(generic_function
  function: (identifier) @function)
(generic_function
  function: (scoped_identifier
    name: (identifier) @function))
(generic_function
  function: (field_expression
    field: (field_identifier) @function))

; Assume other uppercase names are enum constructors
((field_identifier) @constant
 (#lua-match? @constant "^[A-Z]"))

(enum_variant
  name: (identifier) @constant)

; Assume that uppercase names in paths are types
(scoped_identifier
  path: (identifier) @namespace)
(scoped_identifier
 (scoped_identifier
  name: (identifier) @namespace))
(scoped_type_identifier
  path: (identifier) @namespace)
(scoped_type_identifier
 (scoped_identifier
  name: (identifier) @namespace))
((scoped_identifier
  path: (identifier) @type)
 (#lua-match? @type "^[A-Z]"))
((scoped_identifier
    name: (identifier) @type)
 (#lua-match? @type "^[A-Z]"))

[
  (crate)
  (super)
] @namespace

(scoped_use_list
  path: (identifier) @namespace)
(scoped_use_list
  path: (scoped_identifier
            (identifier) @namespace))
(use_list (scoped_identifier (identifier) @namespace . (_)))
(use_list (identifier) @type (#lua-match? @type "^[A-Z]"))
(use_as_clause alias: (identifier) @type (#lua-match? @type "^[A-Z]"))

;; Correct enum constructors
(call_expression
  function: (scoped_identifier
    "::"
    name: (identifier) @constant)
  (#lua-match? @constant "^[A-Z]"))

; Assume uppercase names in a match arm are constants.
((match_arm
   pattern: (match_pattern (identifier) @constant))
 (#lua-match? @constant "^[A-Z]"))
((match_arm
   pattern: (match_pattern
     (scoped_identifier
       name: (identifier) @constant)))
 (#lua-match? @constant "^[A-Z]"))

((identifier) @constant.builtin
 (#any-of? @constant.builtin "Some" "None" "Ok" "Err"))

;; Macro definitions
"$" @function.macro
(metavariable) @function.macro
(macro_definition "macro_rules!" @function.macro)

;; Attribute macros
(attribute_item (meta_item (identifier) @function.macro))
(meta_item (scoped_identifier (identifier) @function.macro .))

;; Derive macros (assume all arguments are types)
(meta_item
  (identifier) @_name
  arguments: (meta_arguments (meta_item (identifier) @type))
  (#eq? @_name "derive"))

;; Function-like macros
(macro_invocation
  macro: (identifier) @function.macro)
(macro_invocation
  macro: (scoped_identifier
           (identifier) @function.macro .))



;;; Literals

[
  (line_comment)
  (block_comment)
] @comment

(boolean_literal) @boolean
(integer_literal) @number
(float_literal) @float

[
  (raw_string_literal)
  (string_literal)
] @string
(escape_sequence) @string.escape
(char_literal) @character


;;; Keywords

[
  "use"
  "mod"
] @include
(use_as_clause "as" @include)

[
  "async"
  "await"
  "const"
  "default"
  "dyn"
  "enum"
  "extern"
  "impl"
  "let"
  "match"
  "move"
  "pub"
  "ref"
  "static"
  "struct"
  "trait"
  "type"
  "union"
  "unsafe"
  "where"
  (mutable_specifier)
] @keyword

"fn" @keyword.function
[
  "return"
  "yield"
] @keyword.return

(type_cast_expression "as" @keyword.operator)
(qualified_type "as" @keyword.operator)

(use_list (self) @keyword)
(scoped_use_list (self) @keyword)
(scoped_identifier (self) @keyword)

[
  "else"
  "if"
] @conditional

[
  "break"
  "continue"
  "for"
  "in"
  "loop"
  "while"
] @repeat



;;; Operators & Punctuation

[
  "!"
  "!="
  "%"
  "%="
  "&"
  "&&"
  "&="
  "*"
  "*="
  "+"
  "+="
  "-"
  "-="
  "->"
  ".."
  "..="
  "/"
  "/="
  "<"
  "<<"
  "<<="
  "<="
  "="
  "=="
  "=>"
  ">"
  ">="
  ">>"
  ">>="
  "?"
  "@"
  "^"
  "^="
  "|"
  "|="
  "||"
] @operator

["(" ")" "[" "]" "{" "}"]  @punctuation.bracket
(closure_parameters "|"    @punctuation.bracket)
(type_arguments  ["<" ">"] @punctuation.bracket)
(type_parameters ["<" ">"] @punctuation.bracket)

["," "." ":" "::" ";"] @punctuation.delimiter

(attribute_item "#" @punctuation.special)
(inner_attribute_item ["!" "#"] @punctuation.special)
(macro_invocation "!" @function.macro)
(empty_type "!" @type.builtin)
