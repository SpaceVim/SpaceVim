[
  (lambda)
  (function_definition)

  (for_statement)
  (while_statement)
  (if_statement)
  (class_definition)
  (match_statement)
  (pattern_section)
  (setget)
  (match_body)
  (set_body)
  (get_body)
] @indent.begin

[
  (elif_clause)
  (else_clause)
] @indent.branch

[
 (string)
 (comment)
 (array)
 (dictionary)
 (parenthesized_expression)
 (ERROR)
] @indent.auto

[
  (pass_statement)
  (continue_statement)
  (break_statement)
  (return_statement)
] @indent.dedent

[
  (ERROR "[")
  (ERROR "(")
  (ERROR "{")
] @indent.begin

;; This only works with expanded tabs.
; ((parameters) @indent.align (#set! indent.open_delimiter "(") (#set! indent.close_delimiter ")"))
; ((arguments)  @indent.align (#set! indent.open_delimiter "(") (#set! indent.close_delimiter ")"))

;; The following queries either do not agree with the current body parsing or are
;; attempted workarounds. Specifically as the last statement of a body. Opening
;; a new line in between statements works well.
;;
;; The overall experience is poor, so I've opted for @indent.auto.
;;
;; The gdscript parser will need to be patched to accommodate more interactive
;; edits. As far as I can tell the parser greedily consumes whitespace
;; as a zero-width token which causes trouble when inserting indents.

;; This indents correctly with tabs.
; (arguments) @indent.begin
; (parameters) @indent.begin
; (array) @indent.begin
; (dictionary) @indent.begin
; (parenthesized_expression) @indent.begin

;; Partial workaround for when the cursor is on the bracket character and a newline
;; is created with <o>. Without this the newline is opened with extra
;; indentation.
; (body (_ (array "]" @indent.end) ) _)
;; Problematic behaviors occur at the last statement of a body.
;; with @dedent:
;;   - [ | ] i<CR> will dedent ] to 0.
;;   - [
;;   ]| o will open new line at correct indentation.
;; with @auto:
;;   - [ | ] i<CR> same
;;   - [
;;   ]| o will open new line with extra indent.
;(body (_ (array "]" @indent.auto) ) .)
