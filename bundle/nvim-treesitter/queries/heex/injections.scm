; HEEx directives can span multiple interpolated lines of Elixir
(directive [
  (expression_value) 
  (partial_expression_value)
] @elixir @combined)  

; HEEx Elixir expressions are always within a tag or component
(expression (expression_value) @elixir)

; HEEx comments
(comment) @comment
