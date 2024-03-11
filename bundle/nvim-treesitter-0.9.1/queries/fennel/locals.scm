[
 (program)
 (fn)
 (lambda)
 (let)
 (each)
 (for)
 (match)
] @scope

(
  (list . (symbol) @_special) @scope
  (#any-of? @_special
   "while" "if" "when" "do" "collect" "icollect" "accumulate")
)

(fn name: (symbol) @definition.function
  (#set! definition.function.scope "parent"))
(lambda name: (symbol) @definition.function
  (#set! definition.function.scope "parent"))

; TODO: use @definition.parameter for parameters
(binding (symbol) @definition.var)
(for_clause . (symbol) @definition.var)

(symbol) @reference
