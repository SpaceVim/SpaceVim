(doctest_block) @python

;; Directives with nested content without arguments nor options
((directive
   name: (type) @_type
   body: (body) @rst)
 (#any-of?
  @_type
  "attention" "caution" "danger" "error" "hint" "important" "note" "tip" "warning" "admonition"
  "line-block" "parsed-literal" "epigraph" "highlights" "pull-quote" "compound"
  "header" "footer"
  "meta"
  "replace"))

;; Directives with nested content without arguments, but with options
((directive
   name: (type) @_type
   body: (body (options) (content) @rst))
 (#any-of?
  @_type
  "attention" "caution" "danger" "error" "hint" "important" "note" "tip" "warning" "admonition"
  "line-block" "parsed-literal" "compound"))

;; Directives with nested content with arguments and options
((directive
   name: (type) @_type
   body: (body (content) @rst))
 (#any-of?
  @_type
  "figure"
  "topic" "sidebar" "container"
  "table" "list-table"
  "class" "role" "restructuredtext-test-directive"))

;; Special directives
((directive
   name: (type) @_type
   body: (body (arguments) @language (content) @content))
 (#any-of? @_type "code" "code-block" "sourcecode"))

((directive
   name: (type) @_type
   body: (body (arguments) @language (content) @content))
 (#eq? @_type "raw"))

((directive
   name: (type) @_type
   body: (body (content) @latex))
 (#eq? @_type "math"))

; TODO: re-add when a parser for csv is added.
; ((directive
;    name: (type) @_type
;    body: (body (content) @csv))
;  (#eq? @_type "csv-table"))

;; Special roles - prefix

((interpreted_text
  (role) @_role
  "interpreted_text" @latex)
 (#eq? @_role ":math:"))

;; Special roles - suffix

((interpreted_text
  "interpreted_text" @latex
  (role) @_role)
 (#eq? @_role ":math:"))

(comment) @comment
