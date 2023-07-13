; Scopes

[
  (list)
  (scope)
  (cons)
] @scope

; References

(symbol) @reference

; Definitions

((list
  . (symbol) @_fnkw
  . (symbol) @definition.function
  (symbol)? @definition.parameter)
  (#any-of? @_fnkw "def" "defop" "defn" "fn"))

((cons
  . (symbol) @_fnkw
  . (symbol) @definition.function
  (symbol)? @definition.parameter)
  (#any-of? @_fnkw "def" "defop" "defn" "fn"))
