[
  (compound_statement) 
  (field_declaration_list)
  (case_statement)
  (enumerator_list)
  (compound_literal_expression)
  (initializer_list)
  (init_declarator)
] @indent.begin

; With current indent logic, if we capture expression_statement with @indent.begin
; It will be affected by _parent_ node with error subnodes deep down the tree
; So narrow indent capture to check for error inside expression statement only, 
(expression_statement
  (_) @indent.begin
  ";" @indent.end)

(
  ERROR
    "for" "(" @indent.begin ";" ";" ")" @indent.end)
(
  (for_statement
    body: (_) @_body
  ) @indent.begin
  (#not-has-type? @_body compound_statement)
)

(
  while_statement
    condition: (_) @indent.begin
)
(
  (while_statement
    body: (_) @_body
  ) @indent.begin
  (#not-has-type? @_body compound_statement)
)

(
  (if_statement)
  (ERROR "else") @indent.begin
)

(
 if_statement
  condition: (_) @indent.begin
)
;; Make sure all cases of if-else are tagged with @indent.begin
;; So we will offset the indents for the else case
(
  (if_statement
    consequence: (compound_statement)
    "else" @indent.branch
    alternative: 
      [
        [ "{" "}" ] @indent.branch
        (compound_statement ["{" "}"] @indent.branch)
        (_)
      ] 
  ) @indent.begin
)
(
  (if_statement
    consequence: (_ ";" @indent.end) @_consequence
  ) @indent.begin
  (#not-has-type? @_consequence compound_statement)
)
(
  (if_statement
    consequence: (_) @_consequence
    "else" @indent.branch
    alternative: 
      [
        [ "{" "}" ] @indent.branch
        (compound_statement ["{" "}"] @indent.branch)
        (_)
      ] 
  )
  (#not-has-type? @_consequence compound_statement)
)

;; Dedent for chaining if-else statements
;; this will go recursively through each if-elseif
;; if-elseif -> second `if` is dedented once, indented twice
;; if-elseif-elseif -> third `if` is dedented twice, indented 3 times
;; -> all are indented once
(
  (if_statement
    consequence: (_)
    alternative: 
      [
        (if_statement consequence: (compound_statement) @indent.dedent)
        (_)
      ] @indent.dedent
  )
)

(compound_statement "}" @indent.end)

[
  ")"
  "}"
  (statement_identifier)
] @indent.branch

[
  "#define"
  "#ifdef"
  "#ifndef"
  "#elif"
  "#if"
  "#else"
  "#endif"
] @indent.zero

[
  (preproc_arg)
  (string_literal)
] @indent.ignore

((ERROR (parameter_declaration)) @indent.align
 (#set! indent.open_delimiter "(")
 (#set! indent.close_delimiter ")"))
([(argument_list) (parameter_list)] @indent.align
  (#set! indent.open_delimiter "(")
  (#set! indent.close_delimiter ")"))

(comment) @indent.auto

