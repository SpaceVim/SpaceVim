; Scopes

[
  (script)
  (class_declaration)
  (enum_declaration)
  (function_declaration)
  (attribute_declaration)

  (array)
  (block)
  (table)
  (anonymous_function)
  (parenthesized_expression)

  (if_statement)
  (else_statement)
  (while_statement)
  (do_while_statement)
  (switch_statement)
  (for_statement)
  (foreach_statement)
  (try_statement)
  (catch_statement)
] @scope


; References

[
  (identifier)
  (global_variable)
] @reference

; Definitions

(const_declaration
  . (identifier) @definition.constant)

(enum_declaration
  . (identifier) @definition.enum)

(member_declaration
  (identifier) @definition.field 
  . "=")

(table_slot
  . (identifier) @definition.field
  . ["=" ":"])

((function_declaration
  . (identifier) @definition.function)
  (#not-has-ancestor? @definition.function member_declaration))

(member_declaration
  (function_declaration
    . (identifier) @definition.method))

(class_declaration
  . (identifier) @definition.type)

(var_statement
  "var" . (identifier) @definition.variable)

(local_declaration
  (identifier) @definition.variable 
  . "=")
