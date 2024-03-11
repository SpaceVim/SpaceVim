; let bindings
(let_expression (binding_set (binding . (attrpath) @definition.var))) @scope

; rec attrsets
(rec_attrset_expression (binding_set (binding . (attrpath) @definition.field))) @scope

; functions and parameters
(function_expression . [
    (identifier) @definition.parameter
    (formals (formal . (identifier) @definition.parameter))
]) @scope
((formals) "@" (identifier) @definition.parameter) ; I couldn't get this to work properly inside the (function)

(variable_expression (identifier) @reference)
(inherited_attrs attr: (identifier) @reference)
