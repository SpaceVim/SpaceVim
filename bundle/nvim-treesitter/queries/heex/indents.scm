; HEEx tags, components, and slots indent like HTML
[
  (component)
  (slot)
  (tag)
] @indent

; Dedent at the end of each tag, component, and slot
[
  (end_component)
  (end_slot)
  (end_tag)
] @branch @dedent

; Self-closing tags and components should not change
; indentation level of sibling nodes
[
  (self_closing_component)
  (self_closing_tag)
] @auto
