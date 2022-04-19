(group_graph_pattern (triples_block) @scope)

((sub_select (select_clause (var) @definition.var))
 (#set! "definition.var.scope" "parent"))
((select_query (select_clause (var) @definition.var))
 (#set! "definition.var.scope" "parent"))

(var) @reference
