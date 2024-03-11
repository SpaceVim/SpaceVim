[
  (ast_block)
  (list)
  (array)
  (expr)
  (json_array)
  (json_object)
  (parenthesized_expression)
] @scope

(symbol) @reference

(keyword) @definition.field

(json_object
	(simplexpr
    (ident) @definition.field))

(ast_block
  (symbol)
  (ident) @definition.type)
