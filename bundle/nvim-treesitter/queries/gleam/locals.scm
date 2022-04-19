; Let Binding Definition
(let pattern: (identifier) @definition)

; List Pattern Definitions
(list_pattern (identifier) @definition)
(list_pattern assign: (identifier) @definition)

; Tuple Pattern Definition
(tuple_pattern (identifier) @definition)

; Record Pattern Definition
(record_pattern_argument pattern: (identifier) @definition)

; Function Parameter Definition
(function_parameter name: (identifier) @definition)

; References
(identifier) @reference

; Function Body Scope
(function_body) @scope

; Case Scope
(case_clause) @scope
