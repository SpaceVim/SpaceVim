; HEEx tags, components, and slots indent like HTML
[
  (component)
  (slot)
  (tag)
] @indent.begin

; Dedent at the end of each tag, component, and slot
[
  (end_component)
  (end_slot)
  (end_tag)
] @indent.branch @indent.dedent

; Self-closing tags and components should not change
; indentation level of sibling nodes
[
  (self_closing_component)
  (self_closing_tag)
] @indent.auto
