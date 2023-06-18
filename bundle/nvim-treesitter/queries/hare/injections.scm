(comment) @comment

((call_expression
  . (_) @_fnname
  . "("
  . (_ [(string_content) (raw_string_content)] @regex)
  . ")")
  (#any-of? @_fnname "compile" "regex::compile"))
