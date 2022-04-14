; SCOPES
; declarations
(program) @scope
(class_declaration
  body: (_) @scope)
(record_declaration
  body: (_) @scope)
(enum_declaration
  body: (_) @scope)
(lambda_expression) @scope
(enhanced_for_statement) @scope

; block
(block) @scope

; if/else
(if_statement) @scope ; if+else
(if_statement
  consequence: (_) @scope) ; if body in case there are no braces
(if_statement
  alternative: (_) @scope) ; else body in case there are no braces

; try/catch
(try_statement) @scope ; covers try+catch, individual try and catch are covered by (block)
(catch_clause) @scope ; needed because `Exception` variable

; loops
(for_statement) @scope ; whole for_statement because loop iterator variable
(for_statement         ; "for" body in case there are no braces
  body: (_) @scope)
(do_statement
  body: (_) @scope)
(while_statement
  body: (_) @scope)

; Functions

(constructor_declaration) @scope
(method_declaration) @scope


; DEFINITIONS
(package_declaration
  (identifier) @definition.namespace)
(class_declaration
  name: (identifier) @definition.type)
(record_declaration
  name: (identifier) @definition.type)
(enum_declaration
  name: (identifier) @definition.enum)
(method_declaration
  name: (identifier) @definition.method)

(local_variable_declaration
  declarator: (variable_declarator
                name: (identifier) @definition.var))
(formal_parameter
  name: (identifier) @definition.var)
(catch_formal_parameter
  name: (identifier) @definition.var)
(inferred_parameters (identifier) @definition.var) ; (x,y) -> ...
(lambda_expression
    parameters: (identifier) @definition.var) ; x -> ...
(enhanced_for_statement ; for (var item : items) {
  name: (identifier) @definition.var)

((scoped_identifier
  (identifier) @definition.import)
 (#has-ancestor? @definition.import import_declaration))

(field_declaration
  declarator: (variable_declarator
                name: (identifier) @definition.field))

; REFERENCES
(identifier) @reference
(type_identifier) @reference
