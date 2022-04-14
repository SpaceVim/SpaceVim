; Comments
(comment) @comment

; Documentation
(unary_operator
  operator: "@"
  operand: (call
    target: ((identifier) @_identifier (#any-of? @_identifier "moduledoc" "typedoc" "shortdoc" "doc"))
    (arguments [
      (string (quoted_content) @markdown)
      (sigil (quoted_content) @markdown)
    ])))

; HEEx
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @heex
(#eq? @_sigil_name "H"))

; Surface
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @surface
(#eq? @_sigil_name "F"))

; Zigler
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @eex
(#any-of? @_sigil_name "E" "L"))

(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @zig
(#any-of? @_sigil_name "z" "Z"))

; Regex
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @regex
(#any-of? @_sigil_name "r" "R"))

; Jason
(sigil
  (sigil_name) @_sigil_name
  (quoted_content) @json
(#any-of? @_sigil_name "j" "J"))

