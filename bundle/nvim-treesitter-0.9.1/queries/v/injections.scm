(comment) @comment
;; asm_statement if asm ever highlighted :)

;; #include <...>
(hash_statement) @c

;; regex for the methods defined in `re` module
((call_expression
    name: (selector_expression
      field: (reference_expression (identifier) @_re))
    arguments: (argument_list
  (argument (literal (raw_string_literal) @regex (#offset! @regex 0 2 0 -1)))))
  (#any-of? @_re "regex_base" "regex_opt" "compile_opt"))
