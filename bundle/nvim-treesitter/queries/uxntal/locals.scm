; Scopes

[
  (program)
  (macro)
  (memory_execution)
  (subroutine)
] @scope

; References

(identifier) @reference

; Definitions

(label
  "@"
  . (identifier) @definition.function)

(macro
  "%"
  . (identifier) @definition.macro)
