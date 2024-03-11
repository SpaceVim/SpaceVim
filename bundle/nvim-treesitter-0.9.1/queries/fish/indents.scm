[
 (function_definition)
 (while_statement)
 (for_statement)
 (if_statement)
 (begin_statement)
 (switch_statement)
] @indent.begin

[
 "else" ; else and else if must both start the line with "else", so tag the string directly
 "case"
 "end"
] @indent.branch

"end" @indent.end

(comment) @indent.ignore
