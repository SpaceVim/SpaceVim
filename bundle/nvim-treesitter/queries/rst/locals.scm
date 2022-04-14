;; Scopes

(document) @scope

(directive) @scope

;; Definitions

(title) @definition

(substitution_definition
  name: (substitution) @definition)

(footnote
  name: (label) @definition)

(citation
  name: (label) @definition)

(target
  name: (name) @definition)

; Inline targets
(inline_target) @definition

; The role directive can define a new role
((directive
  name: (type) @_type
  body: (body (arguments) @definition))
 (#eq? @_type "role"))

;; References

[
 (substitution_reference)
 (footnote_reference)
 (citation_reference)
 (reference)
 (role)
] @reference
