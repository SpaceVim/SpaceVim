[(import_declaration)
 (const_declaration)
 (type_declaration)
 (literal_value)
 (type_initializer)
 (block)
 (map)
 (call_expression)
 (parameter_list)]
@indent.begin

[ "}"]
@indent.branch

(parameter_list ")" @indent.branch)

(comment) @indent.ignore
