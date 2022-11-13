; Control flow {{{
(if_expression) @indent
"then" @branch
"else" @branch

(while_expression) @indent
"do" @branch

(for_expression) @indent
"to" @branch
; }}}

; Class {{{
(class_declaration) @indent
(class_declaration "}" @indent_end)

(class_type) @indent
(class_type "}" @indent_end)
; }}}

; Groups {{{
(let_expression) @indent
"in" @branch
"end" @branch
(let_expression "end" @indent_end)

(sequence_expression) @indent
")" @branch
(sequence_expression ")" @indent_end)
; }}}

; Functions and methods {{{
(parameters) @indent
(parameters ")" @indent_end)

(function_call) @indent
(method_call) @indent
")" @branch

(function_declaration) @indent
(primitive_declaration) @indent
(method_declaration) @indent
; }}}

; Values and expressions {{{
(array_value) @indent
"]" @branch
(array_value "]" @indent_end)

(array_expression) @indent
"of" @branch

(record_expression) @indent
"}" @branch
(record_expression "}" @indent_end)

(record_type) @indent
"}" @branch
(record_type "}" @indent_end)

(variable_declaration) @indent
; }}}

; Misc{{{
(comment) @ignore
(string_literal) @ignore
; }}}

; vim: sw=2 foldmethod=marker
