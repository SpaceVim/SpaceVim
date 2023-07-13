; Control flow {{{
(if_expression) @indent.begin
"then" @indent.branch
"else" @indent.branch

(while_expression) @indent.begin
"do" @indent.branch

(for_expression) @indent.begin
"to" @indent.branch
; }}}

; Class {{{
(class_declaration) @indent.begin
(class_declaration "}" @indent.end)

(class_type) @indent.begin
(class_type "}" @indent.end)
; }}}

; Groups {{{
(let_expression) @indent.begin
"in" @indent.branch
"end" @indent.branch
(let_expression "end" @indent.end)

(sequence_expression) @indent.begin
")" @indent.branch
(sequence_expression ")" @indent.end)
; }}}

; Functions and methods {{{
(parameters) @indent.begin
(parameters ")" @indent.end)

(function_call) @indent.begin
(function_call ")" @indent.end)
(method_call) @indent.begin
")" @indent.branch

(function_declaration) @indent.begin
(primitive_declaration) @indent.begin
(method_declaration) @indent.begin
; }}}

; Values and expressions {{{
(array_value) @indent.begin
"]" @indent.branch
(array_value "]" @indent.end)

(array_expression) @indent.begin
"of" @indent.branch

(record_expression) @indent.begin
"}" @indent.branch
(record_expression "}" @indent.end)

(record_type) @indent.begin
"}" @indent.branch
(record_type "}" @indent.end)

(variable_declaration) @indent.begin
; }}}

; Misc{{{
(comment) @indent.ignore
(string_literal) @indent.ignore
; }}}

; vim: sw=2 foldmethod=marker
